//
//  CassiniViewController.swift
//  Cassini
//
//  Created by My Nguyen on 8/25/16.
//  Copyright © 2016 My Nguyen. All rights reserved.
//

import UIKit

class CassiniViewController: UIViewController, UISplitViewControllerDelegate {

    private struct Storyboard {
        static let ShowImageSegue = "Show Image"
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Storyboard.ShowImageSegue {
            // make use of the newly defined property contentViewController in UIViewController
            if let imageController = segue.destinationViewController.contentViewController as? ImageViewController {
                if let button = sender as? UIButton {
                    if let name = button.currentTitle {
                        imageController.imageURL = DemoURL.NASAImageNamed(name)
                        imageController.title = name
                    }
                }
            }
        }
    }

    // set Cassini view controller as its own split view delegate
    override func viewDidLoad() {
        super.viewDidLoad()
        splitViewController?.delegate = self
    }

    // implementation for UISplitViewControllerDelegate
    // this method controls the collapsing of the Detail on top of the Master
    // return true if you do the collapse yourself; return false if you let the system do the collapse
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        // make sure the Master view is this view, which should be the case because of viewDidLoad()
        if primaryViewController.contentViewController == self {
            // if the Detail view is an image view and there's no URL (its image is empty)
            // this occurs when the app starts up
            if let imageController = secondaryViewController.contentViewController as? ImageViewController where imageController.imageURL == nil {
                // do not collapse the Detail on top of the Master
                return true
            }
        }
        // let the system do the collapse
        return false
    }

    // in the main storyboard, first remove the 3 segues from the 3 buttons to the navigation controller
    // of the Detail view, then create this target action from all 3 buttons
    @IBAction func showImage(sender: UIButton) {
        // extract the contentViewController property from the last view controller (the Detail view)
        // this ensures we're in a split (Master-Detail) view
        let lastController = splitViewController?.viewControllers.last?.contentViewController
        if let imageController = lastController as? ImageViewController {
            let imageName = sender.currentTitle
            imageController.imageURL = DemoURL.NASAImageNamed(imageName)
            imageController.title = imageName
        }
    }
}

// extension of existing class UIViewController
extension UIViewController {
    // computed property contentViewController, made available to all classes using UIViewController
    var contentViewController: UIViewController {
        // get method only
        if let navController = self as? UINavigationController {
            // since visibleViewController is optional, if it's nil, then return self
            return navController.visibleViewController ?? self
        } else {
            return self
        }
    }
}