 //
//  Gif.swift
//  GifMaker_Swift_Template
//
//  Created by Kothapalli on 1/8/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation
import UIKit

class Gif {
    var url: URL?
    var caption: String?
    var gifImage: UIImage?
    var videoURL: URL?
    var data: Data?
    
    init(name: String) {
        self.gifImage = UIImage.gif(name: name)!
    }
    
    init(url: URL, videoURL: URL, caption: String?) {
        self.url = url
        self.videoURL = videoURL
        self.caption = caption
        self.gifImage = UIImage.gif(url: url.absoluteString)!
        self.data = nil
    }
}
