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
    
    private lazy var spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    private lazy var noteCountItem: UIBarButtonItem = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        return UIBarButtonItem(customView: label)
    }()
    private lazy var newNoteItem = UIBarButtonItem(image: R.image.write(), style: .plain, target: self, action: #selector(didTapNewNotesButton))
    
    var notebook: Notebook!
    weak var delegate: NoteDetailViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView()
        setUpObservers()
        setUpOthers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateBars()
        updateDelegate()
        defaultSelectNoteWhenExpand()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isToolbarHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.Identifier.SHOWNOTEDETAIL {
            let controller = (segue.destination as! UINavigationController).topViewController as! NoteDetailViewController
            controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true
            
            if let note = sender as? Note {
                controller.note = note
                controller.notebook = notebook
            }
            
            delegate = controller
        }
    }
    
    //MARK: - Objc functions
    @IBAction func didTapOptionButton(_ sender: UIBarButtonItem) {
        
    }
    
    @objc private func didAllNotesLoad() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.updateBars()
            self.defaultSelectNoteWhenExpand()
        }
    }
    
    @objc private func didTapNewNotesButton() {
        if notebook.allLoaded {
            notebook.addNote()
        } else {
            displayAutoDismissAlert(msg: "Notes are loading, just one moment")
        }
    }
    
    @objc private func didSplitViewControllerExpand() {
        DispatchQueue.main.async {
            self.updateBars()
            self.defaultSelectNoteWhenExpand()
        }
    }
    
    @objc private func didAddNote(no: Notification) {
        DispatchQueue.main.async {
            if let note = self.delegate?.note, let index = self.notebook.notes.firstIndex(of: note) {
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                self.tableView.endUpdates()
                
                if self.splitViewController!.isCollapsed && (self.splitViewController?.viewControllers[0] as? UINavigationController)?.topViewController == self {
                    self.performSegue(withIdentifier: Constant.Identifier.SHOWNOTEDETAIL, sender: note)
                }
                self.updateBars()
            }
        }
    }
    
    @objc private func didUpdateNote(no: Notification) {
        DispatchQueue.main.async {
            if let note = no.object as? Note, let index = self.notebook.notes.firstIndex(of: note) {
                let selectedIndexPath = self.tableView.indexPathForSelectedRow
                self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                self.tableView.selectRow(at: selectedIndexPath, animated: false, scrollPosition: .none)
            }
        }
    }
    
    @objc private func didRemoveNote(no: Notification) {
        DispatchQueue.main.async {
            if let index = no.userInfo?["index"] as? Int {//The index will be removed
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                self.tableView.endUpdates()
                self.updateBars()
            }
            
            if let note = self.delegate?.note, let row = self.notebook.notes.firstIndex(of: note) {
                self.tableView.selectRow(at: IndexPath(row: row, section: 0), animated: false, scrollPosition: .none)
            } else {
                if let split = self.splitViewController, split.isCollapsed {//collapsed
                    self.navigationController?.popToViewController(self, animated: true)
                }
            }
        }
    }
}

//MARK: - Helper functions
extension NotesViewController {
    private func updateDelegate() {
        if let split = splitViewController,
            split.viewControllers.count > 1,
            let nav = split.viewControllers.last as? UINavigationController,
            let detailViewController = nav.topViewController as? NoteDetailViewController {
            delegate = detailViewController
        }
    }
    
    private func defaultSelectNoteWhenExpand() {
        if !splitViewController!.isCollapsed {
            
            if !notebook.allLoaded || notebook.notes.isEmpty { //show empty
                performSegue(withIdentifier: Constant.Identifier.SHOWNOTEDETAIL, sender: nil)
            } else if let note = delegate?.note, let row = notebook.notes.firstIndex(of: note) {
                tableView.selectRow(at: IndexPath(row: row, section: 0), animated: false, scrollPosition: .middle)
                tableView(tableView, didSelectRowAt: IndexPath(row: row, section: 0))
            } else {
                tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .middle)
                tableView(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
            }
        }
    }
    
    private func updateBars() {
        //buttom tool bar
        let items: [UIBarButtonItem]
        if let label = noteCountItem.customView as? UILabel {
            label.text = "\(notebook.notes.count) notes"
            label.sizeToFit()
        }
        
        if let split = splitViewController,
            split.isCollapsed || notebook.notes.isEmpty {
            items = [spaceItem, noteCountItem, spaceItem, newNoteItem]
        } else {
            items = [spaceItem, noteCountItem, spaceItem]
        }
        
        toolbarItems = items
    }
    
    private func configure(_ cell: NoteCell, with note: Note) {
        cell.titleLabel.text = note.title.string
        cell.detailLabel.text = note.content.string
        cell.dateLabel.text = note.date.formattedDate
    }
    
    private func setUpTableView() {
        tableView.register(UINib(resource: R.nib.noteCell), forCellReuseIdentifier: Constant.Identifier.NOTECELL)
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        tableView.backgroundView = UIImageView(image: R.image.paper_light())
        tableView.allowsMultipleSelection = false
    }
    
    private func setUpObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(didAllNotesLoad), name: .didAllNotesLoad, object: notebook)
        NotificationCenter.default.addObserver(self, selector: #selector(didSplitViewControllerExpand), name: .didSplitViewControllerExpand, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didAddNote), name: .didAddNote, object: notebook)
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateNote), name: .didUpdateNote, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didRemoveNote), name: .didRemoveNote, object: notebook)
    }
    
    private func setUpOthers() {
        navigationItem.title = "Notes"
        tabBarController?.tabBar.isHidden = true
        navigationController?.isToolbarHidden = false
        navigationController?.toolbar.setBackgroundImage(R.image.paper_light(), forToolbarPosition: .any, barMetrics: .default)
        navigationController?.toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
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
        let note = notebook.notes[indexPath.row]
        delegate?.note = note
        performSegue(withIdentifier: Constant.Identifier.SHOWNOTEDETAIL, sender: note)
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
