//
//  Header.swift
//  ChikaChatCreator
//
//  Created by Mounir Ybanez on 2/17/18.
//  Copyright © 2018 Nir. All rights reserved.
//

import UIKit

class Header: UIView {

    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        avatarView.layer.borderWidth = 1
        avatarView.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatarView.layer.cornerRadius = min(avatarView.bounds.width, avatarView.bounds.height) / 2
        
        containerView.subviews.forEach { subview in
            subview.frame = containerView.bounds
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        size.height = containerView.frame.maxY
        return size
    }
    
}

extension Header: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
