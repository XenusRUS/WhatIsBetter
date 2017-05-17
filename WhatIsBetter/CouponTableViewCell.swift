//
//  CouponTableViewCell.swift
//  WhatIsBetter
//
//  Created by admin on 07.05.17.
//  Copyright © 2017 vadim. All rights reserved.
//

import UIKit

class CouponTableViewCell: UITableViewCell {

    @IBOutlet weak var couponName: UILabel!
    @IBOutlet weak var couponImage: UIImageView!
    
    @IBOutlet weak var nameCoupon: UILabel!
    @IBOutlet weak var imageCoupon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
