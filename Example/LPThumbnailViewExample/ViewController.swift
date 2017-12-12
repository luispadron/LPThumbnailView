//
//  ViewController.swift
//  LPThumbnailViewExample
//
//  Created by Luis Padron on 12/8/17.
//  Copyright © 2017 Luis Padron. All rights reserved.
//

import UIKit
import LPThumbnailView

class ViewController: UIViewController, LPThumbnailViewDelegate {

    var touchCount = 0

    @IBOutlet weak var thumbnailView: LPThumbnailView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set delegate
        self.thumbnailView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func animationStyle() -> LPThumbnailViewAnimationStyle {
        let rand = arc4random_uniform(5)
        switch rand {
        case 0: return .enterFromRight
        case 1: return .enterFromLeft
        case 2: return .enterFromTop
        case 3: return .enterFromBottom
        case 4: return .crossDissolve
        default: return .enterFromRight
        }
    }

    // Animates the thumbnail view using a context image view
    @IBAction func touchedWithContext(_ sender: Any) {
        let imgView = UIImageView(image: touchCount % 2 == 0 ? #imageLiteral(resourceName: "ExampleImg2") : #imageLiteral(resourceName: "ExampleImg"))
        imgView.frame = self.view.frame
        self.view.addSubview(imgView)
        thumbnailView.addImageWithContext(imgView)
        touchCount += 1
    }

    // Adds an image view using a random animation style
    @IBAction func touched(_ sender: Any) {
        thumbnailView.animationStyle = animationStyle()
        thumbnailView.addImage(touchCount % 2 == 0 ? #imageLiteral(resourceName: "ExampleImg2") : #imageLiteral(resourceName: "ExampleImg"))
        touchCount += 1
    }

    /// Removes the last added image
    @IBAction func removeButtonTouched(_ sender: Any) {
        self.thumbnailView.removeImage()
    }

    /// Asks for an index to delete an image
    @IBAction func removeButtonIndexTouched(_ sender: Any) {
        let alert = UIAlertController(title: "Index of image to delete", message: nil, preferredStyle: .alert)
        alert.addTextField { (textfield) in
            textfield.placeholder = "Index"
            textfield.textColor = .black
        }
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { _ in
            guard let field = alert.textFields?.first else { return }
            DispatchQueue.main.async {
                self.thumbnailView.removeImage(at: Int(field.text!)!)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }

    func thumbnailViewWasTapped(_ view: LPThumbnailView) {
        print("Thumbnail tapped!")
    }
}
