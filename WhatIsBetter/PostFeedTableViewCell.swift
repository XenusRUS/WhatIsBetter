//
//  PostFeedTableViewCell.swift
//  WhatIsBetter
//
//  Created by admin on 21.02.17.
//  Copyright © 2017 vadim. All rights reserved.
//

import UIKit

class PostFeedTableViewCell: UITableViewCell {
    @IBOutlet weak var postNameLabel: UILabel!
    @IBOutlet weak var VSLabel: UILabel!
    @IBOutlet weak var imageOne: UIImageView!
    @IBOutlet weak var imageTwo: UIImageView!

    @IBOutlet weak var titleHistoryLabel: UILabel!
    @IBOutlet weak var imageOneHistory: UIImageView!
    @IBOutlet weak var imageTwoHistory: UIImageView!
    @IBOutlet weak var progressTwo: UIProgressView!
    @IBOutlet weak var progressOne: UIView!
//    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
