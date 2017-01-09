//
//  UIViewController+Record.swift
//  GifMaker_Swift_Template
//
//  Created by Kothapalli on 1/8/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices
import AVFoundation

let frameCount = 16
let delayTime: Float = 0.2
let loopCount = 0

extension UIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBAction func presentVideoOptions(_ sender: Any) {
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            self.launchPhotoLibrary()
        }
        
        else {
            let newGifActionSheet = UIAlertController(title: "Create new GIF", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
            
            let recordVideo = UIAlertAction(title: "Record a Video", style: .default, handler: { (UIAlertAction) in
                self.launchVideoCamera()
            })
            
            let chooseFromExisting = UIAlertAction(title: "Choose from Existing", style: .default, handler: { (UIAlertAction) in
                self.launchPhotoLibrary()
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            newGifActionSheet.addAction(recordVideo)
            newGifActionSheet.addAction(chooseFromExisting)
            newGifActionSheet.addAction(cancel)
            
            present(newGifActionSheet, animated: true, completion: nil)
            let pinkColor = UIColor(red: 255.0/255.0, green: 65.0/255.0, blue: 112.0/255.0, alpha: 1.0)
            newGifActionSheet.view.tintColor = pinkColor
        }
    }
    
    func launchVideoCamera() {
        
        let recordVideoController = UIImagePickerController()
        recordVideoController.sourceType = UIImagePickerControllerSourceType.camera
        recordVideoController.mediaTypes = [kUTTypeMovie as String]
        recordVideoController.allowsEditing = true
        recordVideoController.delegate = self
        
        present(recordVideoController, animated: true, completion: nil)
    }
    
    func launchPhotoLibrary () {
        
        let photoLibraryController = UIImagePickerController()
        photoLibraryController.sourceType = .photoLibrary
        photoLibraryController.delegate = self
        photoLibraryController.mediaTypes = [kUTTypeMovie as String]
        photoLibraryController.allowsEditing = true
        present(photoLibraryController, animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        if mediaType == kUTTypeMovie as String {
            let videoURL = info[UIImagePickerControllerMediaURL] as! NSURL
            
            let start: NSNumber? = info["_UIImagePickerControllerVideoEditingStart"] as? NSNumber
            let end: NSNumber? = info["_UIImagePickerControllerVideoEditingEnd"] as? NSNumber
            var duration: NSNumber?
            if let start = start {
                duration = NSNumber(value: (end!.floatValue) - (start.floatValue))
            } else {
                duration = nil
            }
        
            cropVideoToSquare(rawVideoURL: videoURL, start: start, duration: duration)
            
        }
    }
    
    public func cropVideoToSquare(rawVideoURL: NSURL, start: NSNumber?, duration: NSNumber?) {
        // Create the AVAsset and AVAssetTrack
        let videoAsset = AVAsset(url: rawVideoURL as URL)
        let videoTrack = videoAsset.tracks(withMediaType: AVMediaTypeVideo)[0]
        
        // Crop to square
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = CGSize(width: videoTrack.naturalSize.height, height: videoTrack.naturalSize.height)
        videoComposition.frameDuration = CMTimeMake(1, 30)
        
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(60, 30))
        
        // Rotate to portrait
        let transformer = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
        let t1 = CGAffineTransform(translationX: videoTrack.naturalSize.height, y: -(videoTrack.naturalSize.width - videoTrack.naturalSize.height)/2 );
        let t2 = t1.rotated(by: CGFloat(M_PI_2));
        
        let finalTransform = t2
        transformer.setTransform(finalTransform, at: kCMTimeZero)
        instruction.layerInstructions = [transformer]
        videoComposition.instructions = [instruction]
        
        // Export
        let exporter = AVAssetExportSession(asset: videoAsset, presetName: AVAssetExportPresetHighestQuality)!
        let path = createPath()
        
        exporter.videoComposition = videoComposition
        exporter.outputURL = path as URL
        exporter.outputFileType = AVFileTypeQuickTimeMovie
        
        var squareURL = NSURL()
        exporter.exportAsynchronously {
            squareURL = exporter.outputURL! as NSURL
            self.convertVideoToGIF(videoURL: squareURL, start: start, duration: duration)
        }
    }
    
    public func createPath () -> NSURL {
        let manager = FileManager.default
        let documentsDirectory = manager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let outputDirectory = documentsDirectory.appendingPathComponent("output")
        let outputURL = outputDirectory.appendingPathComponent("output.mov")

        
        do {
            try manager.createDirectory(atPath: outputDirectory.path, withIntermediateDirectories: true, attributes: nil)
            try manager.removeItem(at: outputURL)
        } catch let error as NSError {
            NSLog(error.description)
        }
        
        return outputURL as NSURL
    }
    
    func convertVideoToGIF(videoURL: NSURL, start: NSNumber?, duration: NSNumber?) {
        let regift: Regift
        if let start = start {
            // Trimmed
            regift = Regift(sourceFileURL: videoURL as URL, destinationFileURL: nil, startTime: start.floatValue, duration: duration!.floatValue, frameRate: frameCount, loopCount: loopCount)
        } else {
            // Untrimmed
            regift = Regift(sourceFileURL: videoURL as URL, destinationFileURL: nil, frameCount: frameCount, delayTime: delayTime, loopCount: loopCount)
        }
        let gifURL  = regift.createGif()
        let gif = Gif(url: gifURL!, videoURL: videoURL as URL, caption: nil)
        displayGIF(gif: gif)
    }
    
    func displayGIF(gif: Gif) {
        let gifEditorVC = storyboard?.instantiateViewController(withIdentifier: "GifEditorViewController") as! GifEditorViewController
        
        gifEditorVC.gif = gif
        
        navigationController?.pushViewController(gifEditorVC, animated: true)
    }
    
}

