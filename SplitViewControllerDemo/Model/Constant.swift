//
//  Constant.swift
//  SplitViewControllerDemo
//
//  Created by tongyi on 12/3/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

enum Constant {
    enum Identifier {
        static let NOTEBOOKCELL = "NOTEBOOKCELL"
        static let NOTEBOOKHEADER = "NOTEBOOKHEADER"
        static let SHOWNOTES = "SHOWNOTES"
        static let NOTECELL = "NOTECELL"
        static let SHOWNOTEDETAIL = "SHOWNOTEDETAIL"
    }
    
    enum Strings {
        static let myNotebooks = "My notebooks"
        static let sharedWithMe = "Shared with me"
        static let iSharedTo = "I shared to"
        
        static let refreshingText = "Pull to refresh"
    }
    
    enum AssociatedObjectKey {
        static var placeHolder = "placeHolder"
        static var placeholderLabel = "placeholderLabel"
    }
}
