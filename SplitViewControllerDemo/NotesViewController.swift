//
//  NotesViewController.swift
//  SplitViewControllerDemo
//
//  Created by Yi Tong on 12/3/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import UIKit
import SnapKit
import DZNEmptyDataSet

class NotesViewController: UITableViewController {
    
    var notebook: Notebook!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView()
        setUpObservers()
        setUpOthers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
        showToolbar()
        
        if !notebook.allLoaded {
            //displayLoading()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        self.hideToolbar()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let noteDetailViewController = segue.destination as? NoteDetailViewController, let indexPath = sender as? IndexPath {
            noteDetailViewController.note = notebook.notes[indexPath.row]
        }
    }
    
    //MARK: - Objc functions
    @IBAction func didTapOptionButton(_ sender: UIBarButtonItem) {
        
    }
    
    @objc private func didAllNotesLoad() {
        //dismissLoading()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc private func didTapNewNotesButton() {
        print("new notes")
    }
}

//MARK: - Helper functions
extension NotesViewController {
    private func dismissLoading() {
        
    }
    
    private func displayLoading() {
        
    }
    
    private func hideToolbar() {
        navigationController?.isToolbarHidden = true
    }
    
    private func showToolbar() {
        navigationController?.isToolbarHidden = false
        navigationController?.toolbar.barTintColor = .white
        navigationController?.toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let newNoteButton = UIBarButtonItem(image: R.image.write(), style: .plain, target: self, action: #selector(didTapNewNotesButton))
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "\(notebook.notes.count) notes", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)])
        let noteCountLabel = UIBarButtonItem(customView: label)
        toolbarItems = [space, noteCountLabel, space, newNoteButton]
    }
    
    private func configure(_ cell: NoteCell, with note: Note) {
        cell.titleLabel.text = note.title
        cell.detailLabel.text = note.title
        cell.dateLabel.text = note.date?.formattedDate
    }
    
    private func setUpTableView() {
        tableView.register(UINib(resource: R.nib.noteCell), forCellReuseIdentifier: Constant.Identifier.NOTECELL)
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
    }
    
    private func setUpObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(didAllNotesLoad), name: .didAllNotesLoad, object: notebook)
    }
    
    private func setUpOthers() {
        navigationItem.title = "Notes"
        navigationItem.largeTitleDisplayMode = .never
    }
}

//MARK: - UITableView datasource and delegate
extension NotesViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notebook.allLoaded ? notebook.notes.count : 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.Identifier.NOTECELL, for: indexPath) as! NoteCell
        let note = notebook.notes[indexPath.row]
        
        configure(cell, with: note)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: Constant.Identifier.SHOWNOTEDETAIL, sender: indexPath)
    }
}

extension NotesViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        let waitingView = WaitingView(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        
        if notebook.allLoaded {
            waitingView.setMsg("No notes")
            waitingView.stopAnimating()
        } else {
            waitingView.setMsg("Loading...")
            waitingView.startAnimating()
        }
        
        return waitingView
    }
}
