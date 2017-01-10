//
//  SavedGifsViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Kothapalli on 1/9/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class SavedGifsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyView: UIStackView!
    var savedGifs = [Gif]()
    let cellMargin: CGFloat = 12.0
    
    var gifsFilePath: String {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let gifsPath = documentsPath.appending("/savedGifs")
        return gifsPath
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emptyView.isHidden = (savedGifs.count != 0)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedGifs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GifCell", for: indexPath) as! GifCell
        
        let gif = savedGifs[indexPath.item]
        cell.configureForGif(gif: gif)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width/2 - (cellMargin*2.0))/2.0
        
        return  CGSize(width: width, height: width)
        
    }
    
    
}

extension SavedGifsViewController: PreviewViewControllerDelegate {
    func previewVC(preview: PreviewViewController, didSaveGif gif: Gif) {
        do {
            gif.data = try Data(contentsOf: gif.url!)
            savedGifs.append(gif)
        }
        catch {
            // Error handling
        }
    }
}
