//
//  NoteDetailViewController.swift
//  SplitViewControllerDemo
//
//  Created by Yi Tong on 12/5/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import UIKit
import YYText
import SnapKit

class NoteDetailViewController: UIViewController {
    weak var titleTextField: UITextField!
    weak var contentTextView: UITextView!
    weak var emptyLabel: UILabel!
    
    private let delay: TimeInterval = 0.5
    private var autoSaveTimer: Timer?
    
    var note: Note? {
        didSet {
            configureView()
        }
    }
    
    var notebook: Notebook?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        configureView()
        addObservers()
        reset()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateBars()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    //MARK: - Objc functions
    @objc private func didTapTrashItem() {
        guard let note = note else { return }
        note.notebook.removeNote(note)
    }
    
    @objc private func didTapCameraItem() {
        
    }
    
    @objc private func didTapNewNoteItem() {
        guard let note = note else { return }
        note.notebook.addNote()
    }
    
    @objc private func textFieldChanged(textField: UITextField) {
        print("titiel changed")
        autoSave(delay: delay)
    }
    
    @objc private func didAddNote(no: Notification) {
        if let newNote = no.userInfo?["note"] as? Note {
            note = newNote
        }
    }
    
    @objc private func didRemoveNote(no: Notification) {
        //display animation: deleted
        if let notebook = no.object as? Notebook {
            note = notebook.notes.first
        }
    }
}

extension NoteDetailViewController {
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(didAddNote), name: .didAddNote, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didRemoveNote), name: .didRemoveNote, object: nil)
    }
    
    private func customDismiss() {
        let transition = CATransition()
        transition.duration = 0.35
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .fade
        view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
    }
    
    private func reset() {
        autoSaveTimer?.invalidate()
        contentTextView.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        titleTextField.defaultTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22, weight: .medium)]
    }
    
    private func autoSave(delay: TimeInterval) {
        guard let note = note else { return }
        autoSaveTimer?.invalidate()
        autoSaveTimer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false, block: { (timer) in
            note.update(title: self.titleTextField.attributedText, content: self.contentTextView.attributedText)
        })
    }
    
    private func updateBars() {
        //buttom tool bar
        navigationController?.toolbar.setBackgroundImage(R.image.paper_light(), forToolbarPosition: .any, barMetrics: .default)
        navigationController?.toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let trashItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTapTrashItem))
        let cameraItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(didTapCameraItem))
        let newNoteItem = UIBarButtonItem(image: R.image.write(), style: .plain, target: self, action: #selector(didTapNewNoteItem))
        toolbarItems = [trashItem, space, cameraItem, space, newNoteItem]
    }
    
    private func configureView() {
        if let emptyLabel = emptyLabel {
            if let note = note {
                navigationController?.isToolbarHidden = false
                emptyLabel.isHidden = true
                contentTextView.attributedText = note.content
                titleTextField.attributedText = note.title
            } else {
                emptyLabel.isHidden = false
                navigationController?.isToolbarHidden = true
            }
        }
    }
    
    private func setUp() {
        let contentTextView = UITextView()
        contentTextView.delegate = self
        self.contentTextView = contentTextView
        contentTextView.backgroundColor = .clear
        view.addSubview(contentTextView)
        
        let titleTextField = UITextField()
        titleTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        self.titleTextField = titleTextField
        titleTextField.placeholder = "Title"
        view.addSubview(titleTextField)
        
        let emptyLabel = UILabel()
        emptyLabel.layer.zPosition = UIWindow.Level.statusBar.rawValue + 1
        emptyLabel.backgroundColor = .white
        emptyLabel.textAlignment = .center
        emptyLabel.text = "No note selected"
        emptyLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        emptyLabel.isHidden = true
        self.emptyLabel = emptyLabel
        view.addSubview(emptyLabel)
        
        titleTextField.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(30)
        }
        
        contentTextView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(titleTextField.snp.bottom)
        }
        
        emptyLabel.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
}

extension NoteDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        autoSave(delay: delay)
    }
}

extension NoteDetailViewController: UITextFieldDelegate {
}
