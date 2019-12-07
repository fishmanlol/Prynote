//
//  PrimarySplitViewController.swift
//  SplitViewControllerDemo
//
//  Created by Yi Tong on 12/5/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import UIKit

class MasterSplitViewController: UISplitViewController, UISplitViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.preferredDisplayMode = .allVisible
        let navigationController = viewControllers[viewControllers.count - 1] as! UINavigationController
        navigationController.topViewController!.navigationItem.leftBarButtonItem = displayModeButtonItem
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        guard let navigationController = secondaryViewController as? UINavigationController else { return false }
        guard let noteDetailViewController = navigationController.topViewController as? NoteDetailViewController else { return false }
        if noteDetailViewController.note == nil {
            
            return true
        }
        
        return false
    }
}
