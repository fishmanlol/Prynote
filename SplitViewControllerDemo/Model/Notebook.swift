//
//  Notebook.swift
//  SplitViewControllerDemo
//
//  Created by Yi Tong on 12/3/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import Foundation

class Notebook {
    var title: String
    var notes: [Note] = [Note(url: ""), Note(url: ""), Note(url: ""), Note(url: "")]
    var allLoaded = false
    
    init(title: String) {
        self.title = title
        let group = DispatchGroup()
        for note in notes {
            group.enter()
            note.load {
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            self.allLoaded = true
            NotificationCenter.default.post(name: .didAllNotesLoad, object: self, userInfo: nil)
        }
    }
    
    func contains(_ note: Note) -> Bool {
        return notes.contains(note)
    }
}
