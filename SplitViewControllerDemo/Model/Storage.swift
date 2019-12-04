//
//  NotebookStore.swift
//  SplitViewControllerDemo
//
//  Created by Yi Tong on 12/3/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import Foundation

struct Storage {
    var myNoteBooks: [Notebook] = []
    var sharedWithMe: [Notebook] = []
    var iSharedTo: [Notebook] = []
    
    init() {
        myNoteBooks = [
            Notebook(title: "First Notebook",
                     notes: [
                        Note(content: "aaaa"),
                        Note(content: "bbbb"),
                        Note(content: "cccc"),
                    ]),
            Notebook(title: "Second Notebook",
                     notes: [
                        Note(content: "dddd"),
                        Note(content: "eeee"),
                        Note(content: "ffff"),
                ]),
            Notebook(title: "Third Notebook",
                     notes: [
                        Note(content: "gggg"),
                        Note(content: "hhhh"),
                        Note(content: "iiii"),
                ]),
        ]
        
        sharedWithMe = [
            Notebook(title: "Tony",
                     notes: [
                        Note(content: "AAAA"),
                        Note(content: "BBBB"),
                        Note(content: "CCCC"),
                ]),
            Notebook(title: "Sam",
                     notes: [
                        Note(content: "DDDD"),
                        Note(content: "EEEE"),
                        Note(content: "FFFF"),
                ]),
            Notebook(title: "Lee",
                     notes: [
                        Note(content: "GGGG"),
                        Note(content: "HHHH"),
                        Note(content: "IIII"),
                ]),
        ]
    }
}
