 //
//  Gif.swift
//  GifMaker_Swift_Template
//
//  Created by Kothapalli on 1/8/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation
import UIKit

 class Gif: NSObject, NSCoding{
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
    
    required init?(coder aDecoder: NSCoder) {
        self.url = aDecoder.decodeObject(forKey: "url") as? URL
        self.videoURL = aDecoder.decodeObject(forKey: "videoURL") as? URL
        self.caption = aDecoder.decodeObject(forKey: "caption") as? String
        self.gifImage = aDecoder.decodeObject(forKey: "gifImage") as? UIImage
        self.data = aDecoder.decodeObject(forKey: "gifData") as? Data
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.url, forKey: "url")
        aCoder.encode(self.videoURL, forKey: "videoURL")
        aCoder.encode(self.caption, forKey: "caption")
        aCoder.encode(self.gifImage, forKey: "gifImage")
        aCoder.encode(self.data, forKey: "gifData")
    }
}
