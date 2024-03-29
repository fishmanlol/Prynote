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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    //MARK: - Objc functions
    @objc private func didPullToRefreshing(refreshControl: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            refreshControl.endRefreshing()
        }
    }
    
    @objc private func didUpdateStorage(no: Notification) {
        if isViewLoaded {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @objc private func didAddOrRemoveNote(no: Notification) {
        if let notebook = no.object as? Notebook {
            #warning("fix needed")
            for (section, block) in Storage.shared.notebookBlocks.enumerated() where !block.isFold {
                if let row = block.notebooks.firstIndex(of: notebook) {
                    DispatchQueue.main.async {
                        self.tableView.beginUpdates()
                        self.tableView.reloadRows(at: [IndexPath(row: row, section: section)], with: .automatic)
                        self.tableView.endUpdates()
                    }
                }
            }
        }
    }
    
    @IBAction func didTapNewNotebookButton(_ sender: UIBarButtonItem) {
        tableView.reloadData()
    }
    
    //MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.Identifier.SHOWNOTES {
            if let notesViewController = segue.destination as? NotesViewController, let indexPath = sender as? IndexPath {
                notesViewController.notebook = getNotebook(in: indexPath)
            }
        }
    }
}

//MARK: - Helper functions
extension NotebooksViewController {
    private func getNotebook(in indexPath: IndexPath) -> Notebook {
        return Storage.shared.notebookBlocks[indexPath.section].notebooks[indexPath.row]
    }
    
    private func isFold(in section: Int) -> Bool {
        return Storage.shared.notebookBlocks[section].isFold
    }
    
    private func configure(_ header: NotebookHeader, with notebookBlock: NotebookBlock) {
        header.setFolded(notebookBlock.isFold, animated: false)
        header.titleLabel.text = notebookBlock.title
    }
    
    private func configure(_ cell: NotebookCell, with notebook: Notebook) {
        cell.titleLabel.text = notebook.title
        cell.notesCountLabel.text = "\(notebook.notes.count)"
    }
    
    private func setUpOthers() {
        navigationItem.title = "Notebooks"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.setBackgroundImage(R.image.paper_light(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func setUpTableView() {
        tableView.register(UINib(resource: R.nib.notebookCell), forCellReuseIdentifier: Constant.Identifier.NOTEBOOKCELL)
        tableView.register(UINib(resource: R.nib.notebookHeader), forHeaderFooterViewReuseIdentifier: Constant.Identifier.NOTEBOOKHEADER)
        tableView.separatorStyle = .none
        tableView.backgroundView = UIImageView(image: R.image.paper_light())
    }
    
    private func setUpRefreshing() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: Constant.Strings.refreshingText)
        refreshControl.addTarget(self, action: #selector(didPullToRefreshing), for: .valueChanged)
        self.refreshControl = refreshControl
    }
    
    private func setUpObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateStorage), name: .didUpdateStorage, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didAddOrRemoveNote), name: .didRemoveNote, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didAddOrRemoveNote), name: .didAddNote, object: nil)
    }
}

//MARK: - Notebook header delegate
extension NotebooksViewController: NotebookHeaderDelegate {
    func noteBookHeaderFoldStatusChanged(_ header: NotebookHeader, foldStatus: Bool, in section: Int) {
        Storage.shared.notebookBlocks[section].isFold = foldStatus
        tableView.beginUpdates()
        tableView.reloadSections([section], with: .fade)
        tableView.endUpdates()
    }
}

//MARK: - UITableView datasource and delegate
extension NotebooksViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Storage.shared.notebookBlocks.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let folded = isFold(in: section)
        return folded ? 0 : Storage.shared.notebookBlocks[section].notebooks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.Identifier.NOTEBOOKCELL) as! NotebookCell
        let notebook = getNotebook(in: indexPath)
        configure(cell, with: notebook)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constant.Identifier.NOTEBOOKHEADER) as! NotebookHeader
        header.section = section
        header.delegate = self
        let notebookBlock = Storage.shared.notebookBlocks[section]
        configure(header, with: notebookBlock)
        return header
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: Constant.Identifier.SHOWNOTES, sender: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 56
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}

