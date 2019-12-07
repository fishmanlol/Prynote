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
    weak var textView: YYTextView!
    weak var backgroundImageView: UIImageView!
    
    var note: Note? {
        didSet {
            configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        setUpOthers()
        
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateBars()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

extension NoteDetailViewController {
    private func updateBars() {
        if let split = splitViewController, split.isCollapsed {
            tabBarController?.tabBar.isHidden = true
        }
    }
    
    private func configureView() {
        if let note = note {
            if let textView = textView {
                textView.text = note.content
            }
        }
    }
    
    private func setUpOthers() {
        
//        if let splitViewController = splitViewController, splitViewController.isCollapsed, splitViewController.displayMode == .primaryHidden {
//            displayRightBarItemsCollapsed()
//            displayToolbarCollapsed()
//        } else {
//            displayRightBarItemsNotCollapsed()
//            displayToolbarNotCollapsed()
//        }
    }
    
    private func setUpViews() {
        let backgroundImageView = UIImageView(image: R.image.paper_light())
        self.backgroundImageView = backgroundImageView
        view.addSubview(backgroundImageView)
        
        let textView = YYTextView()
        self.textView = textView
        view.addSubview(textView)
        
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        textView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
