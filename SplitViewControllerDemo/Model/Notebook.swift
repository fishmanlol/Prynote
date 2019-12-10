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
    var notes: [Note] = []
    var allLoaded = false
    
    init(title: String) {
        self.title = title
        notes = [Note(self), Note(self), Note(self)]
        self.load()
    }
    
    private func load() {
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
    
    func addNote() {
        let note = Note(self)
        notes.insert(note, at: 0)
        NotificationCenter.default.post(name: .didAddNote, object: self, userInfo: ["note": note])
    }
    
    func removeNote(_ note: Note) {
        if let index = notes.firstIndex(of: note) {
            notes.remove(at: index)
            NotificationCenter.default.post(name: .didRemoveNote, object: self, userInfo: ["note": note, "index": index])
        }
    }
}

extension Notebook: Equatable {
    static func ==(lhs: Notebook, rhs: Notebook) -> Bool {
        return lhs === rhs
    }
}
