//
//  NotesViewController.swift
//  SplitViewControllerDemo
//
//  Created by Yi Tong on 12/3/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import UIKit

class NotesViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpOthers()
    }
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 2
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return tableView.dequeueReusableCell(withIdentifier: "NOTECELL")!
//    }
}

//MARK: - Helper functions
extension NotesViewController {
    private func setUpOthers() {
        navigationItem.title = "Notes"
        navigationItem.largeTitleDisplayMode = .never
    }
}
