//
//  NotebookStore.swift
//  SplitViewControllerDemo
//
//  Created by Yi Tong on 12/3/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import Foundation

struct Storage {
    static var shared = Storage()
    
    var notebookBlocks: [NotebookBlock] = []
    
    private init() {}
    
    static func load() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
            let myNoteBooks = [
                Notebook(title: "First Notebook"),
                Notebook(title: "Second Notebook"),
                Notebook(title: "Third Notebook"),
            ]
            
            let sharedWithMe = [
                Notebook(title: "Tony"),
                Notebook(title: "Sam"),
                Notebook(title: "Lee"),
            ]        
            
            shared.notebookBlocks = [
                NotebookBlock(title: Constant.Strings.myNotebooks, notebooks: myNoteBooks, isFold: true),
                NotebookBlock(title: Constant.Strings.sharedWithMe, notebooks: sharedWithMe, isFold: true),
                NotebookBlock(title: Constant.Strings.iSharedTo, notebooks: sharedWithMe, isFold: true),
            ]
            
            NotificationCenter.default.post(name: .didStorageUpdate, object: nil)
        }
    }
}
