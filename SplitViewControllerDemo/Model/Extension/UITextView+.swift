//
//  UITextView+.swift
//  SplitViewControllerDemo
//
//  Created by tongyi on 12/8/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import UIKit

extension UITextView {
    var placeholder: NSAttributedString? {
        set {
            objc_setAssociatedObject(self, &Constant.AssociatedObjectKey.placeHolder, newValue, .OBJC_ASSOCIATION_RETAIN)
            
            initPlaceholder(placeholder!)
        }
        
        get {
            return objc_getAssociatedObject(self, &Constant.AssociatedObjectKey.placeHolder) as? NSAttributedString
        }
    }
    
    private var placeholderLabel: UILabel? {
        set {
            objc_setAssociatedObject(self, &Constant.AssociatedObjectKey.placeholderLabel, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return  objc_getAssociatedObject(self, &Constant.AssociatedObjectKey.placeholderLabel
                ) as? UILabel
        }
    }
    
    private func initPlaceholder(_ placeholder: NSAttributedString) {
        NotificationCenter.default.addObserver(self, selector: #selector(textChange(_:)), name: UITextView.textDidChangeNotification, object: self)
        
        let placeholderLabel = UILabel()
        placeholderLabel.attributedText = placeholder
        placeholderLabel.numberOfLines = 1
        placeholderLabel.lineBreakMode = .byTruncatingTail
        let rect = placeholder.boundingRect(with: CGSize(width: self.frame.size.width - 14, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, context: nil)
        placeholderLabel.frame = CGRect(x: 7, y: 7, width: rect.size.width, height: rect.size.height)
        placeholderLabel.isHidden = self.text.startIndex != self.text.endIndex
        
        addSubview(placeholderLabel)
        self.placeholderLabel = placeholderLabel
    }
    
    @objc private func textChange(_ notification : Notification) {
        
        if placeholder != nil {
            placeholderLabel?.isHidden = true
            if self.text.count ==  0 {
                self.placeholderLabel?.isHidden = false
            }
        }
    }
}
