//
//  SideMenuTableView.swift
//  WhatIsBetter
//
//  Created by admin on 18.02.17.
//  Copyright © 2017 vadim. All rights reserved.
//

import Foundation
import SideMenu

class SideMenuTableView: UITableViewController {
    @IBOutlet weak var avatarImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avatarImage.layer.cornerRadius = 55.5
        avatarImage.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // this will be non-nil if a blur effect is applied
        guard tableView.backgroundView == nil else {
            return
        }
        
        // Set up a cool background image for demo purposes
        let imageView = UIImageView(image: UIImage(named: "saturn"))
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        tableView.backgroundView = imageView
    }
}
