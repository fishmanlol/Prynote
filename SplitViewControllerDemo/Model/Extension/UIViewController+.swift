//
//  UIViewController+.swift
//  SplitViewControllerDemo
//
//  Created by Yi Tong on 12/6/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import UIKit

extension UIViewController {
    var isVisible: Bool {
        return isViewLoaded && view.window != nil
    }
}
