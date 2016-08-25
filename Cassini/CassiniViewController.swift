//
//  CassiniViewController.swift
//  Cassini
//
//  Created by My Nguyen on 8/25/16.
//  Copyright © 2016 My Nguyen. All rights reserved.
//

import UIKit

class CassiniViewController: UIViewController {

    private struct Storyboard {
        static let ShowImageSegue = "Show Image"
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Storyboard.ShowImageSegue {
            // make use of the newly defined property contentController in UIViewController
            if let imageController = segue.destinationViewController.contentController as? ImageViewController {
                if let button = sender as? UIButton {
                    if let name = button.currentTitle {
                        imageController.imageURL = DemoURL.NASAImageNamed(name)
                        imageController.title = name
                    }
                }
            }
        }
    }
}

// extension of existing class UIViewController
extension UIViewController {
    // computed property contentController, made available to all classes using UIViewController
    var contentController: UIViewController {
        // get method only
        if let navController = self as? UINavigationController {
            // since visibleViewController is optional, if it's nil, then return self
            return navController.visibleViewController ?? self
        } else {
            return self
        }
    }
}