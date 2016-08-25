//
//  ImageViewController.swift
//  Cassini
//
//  Created by My Nguyen on 8/24/16.
//  Copyright © 2016 My Nguyen. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    var imageURL: NSURL? {
        didSet {
            image = nil
            fetchImage()
        }
    }
    // create a UIImageView in code as opposed to in the main storyboard
    private var imageView = UIImageView()
    // computed property that stores its data elsewhere (in imageView)
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // view is the top-level view in this view controller
        view.addSubview(imageView)
        // this would result in error: "App Transport Security has blocked a cleartext HTTP"
        // to fix it, in Info.plist, add new Dictionary entry named "App Transport Security Settings"
        // then in this dictionary, add one Boolean entry named "Allow Arbitrary Loads" and set it to YES
        imageURL = NSURL(string: DemoURL.Stanford)
    }

    private func fetchImage() {
        if let url = imageURL {
            // fetch raw image data from the URL
            if let data = NSData(contentsOfURL: url) {
                // create an image out of the raw data;
                // also this triggers the set method of the image property
                image = UIImage(data: data)
            }
        }
    }
}
