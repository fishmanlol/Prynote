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
    weak var noteDetailViewController: NoteDetailViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView()
        setUpObservers()
        setUpOthers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateBars()
        defaultSelectNoteWhenNotCollapsed()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isToolbarHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.Identifier.SHOWNOTEDETAIL {
            if let indexPath = tableView.indexPathForSelectedRow {
                let note = notebook.notes[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! NoteDetailViewController
                controller.note = note
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                noteDetailViewController = controller
            }
        }
    }
    
    //MARK: - Objc functions
    @IBAction func didTapOptionButton(_ sender: UIBarButtonItem) {
        
    }
    
    @objc private func didAllNotesLoad() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.updateBars()
            self.defaultSelectNoteWhenNotCollapsed()
        }
    }
    
    @objc private func didTapNewNotesButton() {
        print("new notes")
    }
    
    @objc private func displayModeChangeToAllVisible() {
        DispatchQueue.main.async {
            self.updateBars()
            self.defaultSelectNoteWhenNotCollapsed()
        }
    }
}

//MARK: - Helper functions
extension NotesViewController {
    private func defaultSelectNoteWhenNotCollapsed() {
        if !splitViewController!.isCollapsed {
            if let note = noteDetailViewController?.note, notebook.contains(note) {
                let row = notebook.notes.firstIndex(of: note)!
                tableView.selectRow(at: IndexPath(row: row, section: 0), animated: false, scrollPosition: .middle)
                tableView(tableView, didSelectRowAt: IndexPath(row: row, section: 0))
            } else {
                tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
                tableView(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
            }
        }
    }
    
    private func updateBars() {
        //buttom tool bar
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "\(notebook.notes.count) notes", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)])
        let noteCountLabel = UIBarButtonItem(customView: label)
        let items: [UIBarButtonItem]
        
        if let split = splitViewController,
            split.isCollapsed {
            let newNoteButton = UIBarButtonItem(image: R.image.write(), style: .plain, target: self, action: #selector(didTapNewNotesButton))
            items = [space, noteCountLabel, space, newNoteButton]
        } else {
            items = [space, noteCountLabel, space]
        }
        
        toolbarItems = items
    }
    
    private func configure(_ cell: NoteCell, with note: Note) {
        cell.titleLabel.text = note.title?.string
        cell.detailLabel.text = note.title?.string
        cell.dateLabel.text = note.date?.formattedDate
    }
    
    private func setUpTableView() {
        tableView.register(UINib(resource: R.nib.noteCell), forCellReuseIdentifier: Constant.Identifier.NOTECELL)
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        tableView.backgroundView = UIImageView(image: R.image.paper_light())
    }
    
    private func setUpObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(didAllNotesLoad), name: .didAllNotesLoad, object: notebook)
        NotificationCenter.default.addObserver(self, selector: #selector(displayModeChangeToAllVisible), name: NSNotification.Name("1"), object: nil)
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
        performSegue(withIdentifier: Constant.Identifier.SHOWNOTEDETAIL, sender: nil)
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
