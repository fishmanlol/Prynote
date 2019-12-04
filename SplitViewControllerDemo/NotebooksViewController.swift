//
//  NotebookViewController.swift
//  SplitViewControllerDemo
//
//  Created by Yi Tong on 12/3/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import UIKit

class NotebooksViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView()
        setUpRefreshing()
        setUpObservers()
        setUpOthers()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Storage.shared.notebookBlocks.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Storage.shared.notebookBlocks[section].notebooks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.Identifier.NOTEBOOKCELL) as! NotebookCell
        let notebook = Storage.shared.notebookBlocks[indexPath.section].notebooks[indexPath.row]
        configure(cell, with: notebook)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UILabel()
        let notebookBlock = Storage.shared.notebookBlocks[section]
        header.text = notebookBlock.title
        return header
    }
    
    //MARK: - Objc functions
    @objc private func didPullToRefreshing(refreshControl: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            refreshControl.endRefreshing()
        }
    }
    
    @objc private func didStorageUpdate(no: Notification) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK: - Helper functions
extension NotebooksViewController {
    private func configure(_ cell: NotebookCell, with notebook: Notebook) {
        cell.titleLabel.text = notebook.title
    }
    
    private func setUpOthers() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setUpTableView() {}
    
    private func setUpRefreshing() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: Constant.Strings.refreshingText)
        refreshControl.addTarget(self, action: #selector(didPullToRefreshing), for: .valueChanged)
        self.refreshControl = refreshControl
    }
    
    private func setUpObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(didStorageUpdate), name: .didStorageUpdate, object: nil)
    }
}
