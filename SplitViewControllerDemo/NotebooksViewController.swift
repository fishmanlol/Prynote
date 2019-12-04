//
//  NotebookViewController.swift
//  SplitViewControllerDemo
//
//  Created by Yi Tong on 12/3/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import UIKit

class NotebooksViewController: UITableViewController {
    
    var storage = Storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpRefreshing()
        setUpObservers()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "NOTEBOOKCELL")!
    }
    
    //MARK: - Objc functions
    @objc private func didPullToRefreshing(refreshControl: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            refreshControl.endRefreshing()
        }
    }
}

//MARK: - Helper functions
extension NotebooksViewController {
    private func setUpRefreshing() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(didPullToRefreshing), for: .valueChanged)
        self.refreshControl = refreshControl
    }
    
    private func setUpObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(did), name: <#T##NSNotification.Name?#>, object: <#T##Any?#>)
    }
}
