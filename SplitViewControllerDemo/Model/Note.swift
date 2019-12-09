//
//  Note.swift
//  SplitViewControllerDemo
//
//  Created by Yi Tong on 12/3/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import Foundation

class Note {
    var date: Date?
    var content: NSAttributedString?
    var title: NSAttributedString?
    var detail: NSAttributedString?
    var url: String?
    
    init(url: String) {
        self.url = String(Int.random(in: Int.min...Int.max))
    }
    
    func load(completion: @escaping () -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
            let html = "<h1>H1 title</h1> <p>p tag<p>"
            self.content = try? NSAttributedString(data: html.data(using: .utf8)!, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            self.title = NSAttributedString(string: "Title - \(Int.random(in: 1...10))")
            self.date = Date()
            completion()
        }
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
        guard let url1 = lhs.url,
                let url2 = rhs.url,
            url1 == url2 else { return false }
        return true
    }
}
