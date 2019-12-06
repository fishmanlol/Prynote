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
    var title: String?
    var content: String?
    var url: String?
    
    init(url: String) {
        self.url = url
    }
    
    func load(completion: @escaping () -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
            self.content = "load - \(Int.random(in: 1...10))"
            self.title = "This is title"
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
