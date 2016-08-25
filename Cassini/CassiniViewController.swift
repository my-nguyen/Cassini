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
            if let imageController = segue.destinationViewController as? ImageViewController {
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
