//
//  CommentTableViewCell.swift
//  WhatIsBetter
//
//  Created by admin on 14.05.17.
//  Copyright © 2017 vadim. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentText: UITextView!
    @IBOutlet weak var createdLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avatarImage = imageLayer(imageView: avatarImage)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func imageLayer(imageView:UIImageView) -> UIImageView {
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds = true
        
        return imageView
    }

}
