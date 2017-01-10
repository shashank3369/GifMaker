//
//  WelcomeViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Kothapalli on 1/8/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    
    @IBOutlet weak var gifImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let proofOfConcept = UIImage.gif(name: "hotlineBling")
        gifImageView.image = proofOfConcept
        
        UserDefaults.standard.set(true, forKey: "WelcomeViewSeen")
        
    }
    
}
