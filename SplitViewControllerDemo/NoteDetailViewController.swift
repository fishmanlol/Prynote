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
    
    var note: Note? {
        didSet {
            configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        configureView()
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
        
    }
    
    @objc private func didTapCameraItem() {
        
    }
    
    @objc private func didTapNewNoteItem() {
        
    }
}

extension NoteDetailViewController {
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
            if let note = note, let content = note.content, let title = note.title {
                navigationController?.isNavigationBarHidden = false
                navigationController?.isToolbarHidden = false
                emptyLabel.isHidden = true
                contentTextView.attributedText = content
                titleTextField.attributedText = title
            } else {
                navigationController?.isNavigationBarHidden = true
                emptyLabel.isHidden = false
                navigationController?.isToolbarHidden = true
            }
        }
    }
    
    private func setUp() {
        let contentTextView = UITextView()
        contentTextView.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        self.contentTextView = contentTextView
        contentTextView.backgroundColor = .clear
        view.addSubview(contentTextView)
        
        let titleTextField = UITextField()
        titleTextField.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        self.titleTextField = titleTextField
        titleTextField.placeholder = "Title"
        view.addSubview(titleTextField)
        
        let emptyLabel = UILabel()
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
    
}
