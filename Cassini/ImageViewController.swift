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
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var imageURL: NSURL? {
        didSet {
            image = nil
            // make sure fetchImage() is called only in the UI
            if view.window != nil {
                fetchImage()
            }
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
            // turn the spinner off once the image is shown
            spinner?.stopAnimating()
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

    // this method is invoked when you're about to appear on screen
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil {
            fetchImage()
        }
    }

    // implementation for UIScrollViewDelegate
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    private func fetchImage() {
        if let url = imageURL {
            // turn spinner on just before switching to background queue to go fetch data over the network
            spinner?.startAnimating()
            let queue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
            dispatch_async(queue) {
                // on a background queue (user initiated), fetch raw image data from the URL
                let contentsOfURL = NSData(contentsOfURL: url)
                dispatch_async(dispatch_get_main_queue()) {
                    // on the main queue
                    if url == self.imageURL {
                        // since the user may have issued multiple requests consecutively, make sure
                        // the url being currently processed is the same one given to the non-main thread
                        // to begin with.
                        if let data = contentsOfURL {
                            // create an image out of the raw data;
                            // also this triggers the set method of the image property
                            self.image = UIImage(data: data)
                        } else {
                            // turn off spinner if no image data could be fetched
                            self.spinner?.stopAnimating()
                        }
                    } else {
                        // if it's not the same URL, just ignore the data
                        print("ignored data returned from url \(url)")
                    }
                }
            }
        }
    }
}
