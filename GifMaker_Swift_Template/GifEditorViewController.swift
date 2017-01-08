//
//  GifEditorViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Kothapalli on 1/8/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class GifEditorViewController: UIViewController {

    @IBOutlet weak var gifImageView: UIImageView!
    
    var gifURL: NSURL? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let gifURL = gifURL {
            let gifFromRecording = UIImage.gif(url: gifURL.absoluteString!)
            gifImageView.image = gifFromRecording
        }
    }

}
