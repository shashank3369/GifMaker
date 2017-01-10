//
//  PreviewViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Kothapalli on 1/8/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

protocol PreviewViewControllerDelegate: class {
    func previewVC(preview: PreviewViewController, didSaveGif gif: Gif)
}

class PreviewViewController: UIViewController {

    var gif: Gif?
    @IBOutlet weak var gifImageView: UIImageView!
    
    weak var delegate: PreviewViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.gifImageView.image = self.gif?.gifImage
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func shareGif(_ sender: Any) {
        do {
            let animatedGif = try Data(contentsOf: (self.gif?.url)!)
            
            let itemsToShare = NSArray(array: [animatedGif])
            
            let shareController = UIActivityViewController(activityItems: itemsToShare as! [Any], applicationActivities: nil)
            
            shareController.completionWithItemsHandler = {(_, completed, _, _) in
                if completed {
                        self.navigationController?.popToRootViewController(animated: true)
                }
            }

            present(shareController, animated: true, completion: nil)
            
        }
        catch {
            // Error handling
        }
    }
    @IBAction func createAndSave(_ sender: Any) {
        delegate?.previewVC(preview: self, didSaveGif: gif!)
        self.navigationController?.popToRootViewController(animated: true)
    }

}
