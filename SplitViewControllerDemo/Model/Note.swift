//
//  Note.swift
//  SplitViewControllerDemo
//
//  Created by Yi Tong on 12/3/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import Foundation

class Note {
    var date = Date()
    var content: NSAttributedString = NSAttributedString(string: "")
    var title: NSAttributedString = NSAttributedString(string: "New Note")
    var detail: NSAttributedString = NSAttributedString(string: "")
    var url: String?
    unowned var notebook: Notebook
    
    init(_ notebook: Notebook) {
        self.notebook = notebook
    }
    
    func load(completion: @escaping () -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
            let html = "<h1>H1 title</h1> <p>p tag</p>"
            self.content = try! NSAttributedString(data: html.data(using: .utf8)!, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            self.title = NSAttributedString(string: "Title - \(Int.random(in: 1...10))")
            completion()
        }
    }
    
    func update(title: NSAttributedString?, content: NSAttributedString?) {
        self.title = title ?? NSAttributedString()
        self.content = content ?? NSAttributedString()
        NotificationCenter.default.post(name: .didUpdateNote, object: self)
    }
    
    deinit {
        print("note deleted!")
    }
    
//    func loadFromLocal() {
//        self.content = "local - \(Int.random(in: 1...10))"
//    }
//
//    func loadFromRemote() {
//        DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
//            self.content = "remote - \(Int.random(in: 1...10))"
//            self.saveInLocal()
//        }
//    }
//    
//    func saveInLocal() {
//
//    }
    
//    init(in notebook: Notebook) {
//        self.notebook = notebook
//        //if has local backup
//        if Bool.random() {
//            content = "local - \(Int.random(in: 1...10))"
//        } else {//no local backup
//            //if has remote url
//            if let _ = remoteURL {
//                DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
//                    self.content = "remote - \(Int.random(in: 1...10))"
//                }
//            }
//        }
//    }
}

extension Note: Equatable {
    static func ==(lhs: Note, rhs: Note) -> Bool {
        return lhs === rhs
    }
}
