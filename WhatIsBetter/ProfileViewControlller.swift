//
//  ProfileViewControlller.swift
//  WhatIsBetter
//
//  Created by admin on 18.02.17.
//  Copyright © 2017 vadim. All rights reserved.
//

import UIKit
import SideMenu
import Alamofire
import KeychainSwift

class ProfileViewControlller: ViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    
    @IBOutlet weak var postStaticLabel: UILabel!
    @IBOutlet weak var pointsStaticLabel: UILabel!
    
    @IBAction fileprivate func close() {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.tintColor = UIColor(red: 164.0/255.0, green: 205.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        // Do any additional setup after loading the view.
        avatarImageView = imageLayer(imageView: avatarImageView)
        
        getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imageLayer(imageView:UIImageView) -> UIImageView {
        imageView.layer.cornerRadius = 75
        imageView.layer.masksToBounds = true
        
        return imageView
    }
    
    func endOfWords(count:NSInteger) -> Bool {
        if (count % 10 != 0) && (count % 10 < 5) && ((count < 11) || (count > 19)) {
            return true
        }
        else {
            return false
        }
    }
    
    func getData() {
        let headers: HTTPHeaders = [
            "Authorization": "Token \(KeychainSwift().get("token")!)",
        ]
        
        Alamofire.request("http://127.0.0.1:8000/users/current/", method: .get, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            if let JSON = response.result.value as? [String: Any] {
                self.nameLabel.text = JSON["username"] as? String
                self.emailLabel.text = JSON["email"] as? String
                
                let userId = JSON["id"] as? NSInteger
                let urlProfile = "http://127.0.0.1:8000/api/userprofile/\(String(describing: userId!))/"
                
                Alamofire.request(urlProfile, method: .get, encoding: URLEncoding.default, headers: headers).responseJSON { response in
                    if let JSON = response.result.value as? [String: Any] {
                        let postCount = JSON["post_count"] as? NSInteger
                        self.postLabel.text = String(describing: postCount!)
                        self.locationLabel.text = JSON["location"] as? String
                        self.birthdayLabel.text = JSON["birthdate"] as? String
                        let points = JSON["points"] as? NSInteger
                        self.pointsLabel.text = String(describing: points!)
                        
                        let avatarUrl = JSON["avatar"] as? String
                        let strurl1 = URL(string: avatarUrl!)
                        let dtinternet1 = try? Data(contentsOf: strurl1!)
                        self.avatarImageView.image = UIImage(data: dtinternet1!)
                        
                        if self.endOfWords(count: postCount!) {
                            self.postStaticLabel.text = "Поста"
                        }
                        if self.endOfWords(count: points!) {
                            self.pointsStaticLabel.text = "Балла"
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "loginVC") as! ViewController
        self.present(nextViewController, animated:true, completion:nil)
        
        KeychainSwift().delete("token")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
