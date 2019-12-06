//
//  NotebookHeader.swift
//  SplitViewControllerDemo
//
//  Created by Yi Tong on 12/4/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import UIKit

protocol NotebookHeaderDelegate: class {
    func noteBookHeaderFoldStatusChanged(_ header: NotebookHeader, foldStatus: Bool, in section: Int)
}

extension NotebookHeaderDelegate {
    func noteBookHeaderFoldStatusChanged(_ header: NotebookHeader, foldStatus: Bool, in section: Int) {}
}

class NotebookHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    var section: Int!
    private(set) var isFolded: Bool = true
    
    weak var delegate: NotebookHeaderDelegate?
    
    @objc func didTapHeader(_ sender: UITapGestureRecognizer) {
        setFolded(!isFolded, animated: true)
        delegate?.noteBookHeaderFoldStatusChanged(self, foldStatus: isFolded, in: section)
    }
    
    func setFolded(_ isFolded: Bool, animated: Bool) {
        self.isFolded = isFolded
        updateFoldStatus(animated: animated)
    }
    
    override func awakeFromNib() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapHeader))
        addGestureRecognizer(tap)
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
    }
    
    private func updateFoldStatus(animated: Bool) {
        if !self.isFolded {
            self.arrowImageView.rotate(.pi * 0.5, animated: animated)
        } else {
            self.arrowImageView.rotate(0, animated: animated)
        }
    }
}
