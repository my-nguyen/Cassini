//
//  ImageViewController.swift
//  Cassini
//
//  Created by My Nguyen on 8/24/16.
//  Copyright © 2016 My Nguyen. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = imageView.frame.size
            // for zooming
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.03
            // maximumZoomScale of 1.0 is the default, meaning to keep the current scale and do not
            // enlarge the picture
            scrollView.maximumZoomScale = 1.0
        }
    }
    var imageURL: NSURL? {
        didSet {
            image = nil
            fetchImage()
        }
    }
    // create a UIImageView in code and not in the main storyboard
    private var imageView = UIImageView()
    // computed property that stores its data elsewhere (in imageView)
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            // must set content size for the view to scroll; similarly for didSet() in scrollView property
            scrollView?.contentSize = imageView.frame.size
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // scroll view is now the top-level view in this view controller, so image view must be added as
        // a subview of the scroll view; note scroll view is added in storyboard and not here in code
        scrollView.addSubview(imageView)
        // this would result in error: "App Transport Security has blocked a cleartext HTTP"
        // to fix it, in Info.plist, add new Dictionary entry named "App Transport Security Settings"
        // then in this dictionary, add one Boolean entry named "Allow Arbitrary Loads" and set it to YES
        // also the Stanford URL is invalid
        // imageURL = NSURL(string: DemoURL.Stanford)
    }

    // implementation for UIScrollViewDelegate
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    private func fetchImage() {
        if let url = imageURL {
            // fetch raw image data from the URL
            if let imageData = NSData(contentsOfURL: url) {
                // create an image out of the raw data;
                // also this triggers the set method of the image property
                image = UIImage(data: imageData)
            }
        }
    }
}
