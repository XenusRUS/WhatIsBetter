//
//  SideMenuTableView.swift
//  WhatIsBetter
//
//  Created by admin on 18.02.17.
//  Copyright © 2017 vadim. All rights reserved.
//

import Foundation
import SideMenu
import Alamofire
import KeychainSwift

class SideMenuTableView: UITableViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        avatarImage.layer.cornerRadius = 55.5
        avatarImage.layer.masksToBounds = true
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 164.0/255.0, green: 205.0/255.0, blue: 255.0/255.0, alpha: 1.0)]
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
    
    func getData() {
        let headers: HTTPHeaders = [
            "Authorization": "Token \(KeychainSwift().get("token")!)",
        ]
        
        Alamofire.request("http://127.0.0.1:8000/users/current/", method: .get, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            if let JSON = response.result.value as? [String: Any] {
                self.nameLabel.text = JSON["username"] as? String
                
                let userId = JSON["id"] as? NSInteger
                let urlProfile = "http://127.0.0.1:8000/api/userprofile/\(String(describing: userId!))/"
                
                Alamofire.request(urlProfile, method: .get, encoding: URLEncoding.default, headers: headers).responseJSON { response in
                    if let JSON = response.result.value as? [String: Any] {
                        let avatarUrl = JSON["avatar"] as? String
                        let strurl1 = URL(string: avatarUrl!)
                        let dtinternet1 = try? Data(contentsOf: strurl1!)
                        self.avatarImage.image = UIImage(data: dtinternet1!)
                    }
                }
            }
        }
    }
    
}
