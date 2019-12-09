//
//  PrimarySplitViewController.swift
//  SplitViewControllerDemo
//
//  Created by Yi Tong on 12/5/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import UIKit

class MasterSplitViewController: UISplitViewController, UISplitViewControllerDelegate, UITabBarControllerDelegate {

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
            //not collapse
            return true
        }
        //collapse
        return false
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, separateSecondaryFrom primaryViewController: UIViewController) -> UIViewController? {
        if let priNav = splitViewController.viewControllers.first as? UINavigationController,
            let top = priNav.topViewController,
            top is NotesViewController,
            splitViewController.viewControllers.count == 1 {
            return R.storyboard.main().instantiateViewController(withIdentifier: "SecondNavController")
        } else {
            return nil
        }
    }
    
    func primaryViewController(forExpanding splitViewController: UISplitViewController) -> UIViewController? {
        NotificationCenter.default.post(name: NSNotification.Name("1"), object: nil)
        return nil
    }
    
//    func primaryViewController(forCollapsing splitViewController: UISplitViewController) -> UIViewController? {
//        <#code#>
//    }
    
//    func splitViewController(_ svc: UISplitViewController, willChangeTo displayMode: UISplitViewController.DisplayMode) {
//        print("will change to display mode \(displayMode.rawValue)")
//        if displayMode == .allVisible {
//            NotificationCenter.default.post(name: NSNotification.Name("1"), object: nil)
//        }
//    }
}
