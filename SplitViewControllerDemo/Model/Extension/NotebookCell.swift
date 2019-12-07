//
//  NotebookCell.swift
//  SplitViewControllerDemo
//
//  Created by tongyi on 12/3/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import UIKit

class NotebookCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var notesCountLabel: UILabel!
    
    override func awakeFromNib() {
        backgroundColor = .clear
    }
}
