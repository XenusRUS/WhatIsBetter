//
//  PostViewController.swift
//  WhatIsBetter
//
//  Created by admin on 23.04.17.
//  Copyright © 2017 vadim. All rights reserved.
//

import UIKit
import SideMenu
import Alamofire
import KeychainSwift

class PostViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
//    var idPost: NSInteger!
//    var namePost: String!
//    var descriptionPost: String!
//    var authorPost: String!
//    var photoOnePost: String!
//    var photoTwoPost: String!
//    var resultOnePost: NSInteger!
//    var resultTwoPost: NSInteger!
//    var createdPost: String!
    var points: NSInteger!
    
    var countComment = 0
    var idArr: NSMutableArray = []
    var usernameArr: NSMutableArray = []
    var avatarArr: NSMutableArray = []
    var commentArr: NSMutableArray = []
    var createdArr: NSMutableArray = []
    
    @IBOutlet weak var addCommentTextView: UITextView!
    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var photoOneImage: UIImageView!
    @IBOutlet weak var photoTwoImage: UIImageView!
    @IBOutlet weak var authorLabel: UIButton!
    @IBOutlet weak var countOneLabel: UILabel!
    @IBOutlet weak var countTwoLabel: UILabel!
    @IBOutlet weak var resultOneBar: UIProgressView!
    @IBOutlet weak var resultTwoBar: UIProgressView!
    
    var postObject : PostModel = PostModel()
    var postArray: NSMutableArray = []
    
    let headers: HTTPHeaders = [
        "Authorization": "Token \(KeychainSwift().get("token")!)",
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 164.0/255.0, green: 205.0/255.0, blue: 255.0/255.0, alpha: 1.0)]
        navigationController?.navigationBar.tintColor = UIColor(red: 164.0/255.0, green: 205.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        loadComments()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupSideMenu()
        showData(post: postObject, postArray: postArray)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setupSideMenu() {
        // Define the menus
        SideMenuManager.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        SideMenuManager.menuRightNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        
        // Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the View Controller it displays!
        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
    }
    
    @IBAction fileprivate func changeSwitch(_ switchControl: UISwitch) {
        SideMenuManager.menuFadeStatusBar = switchControl.isOn
    }
    
    func showImage(urlImage: String) -> UIImage {
        let strurl1 = URL(string: urlImage)
        let dtinternet1 = try? Data(contentsOf: strurl1!)
        let imageView = UIImageView()
        imageView.image = UIImage(data: dtinternet1!)
        
        return imageView.image!
    }
    
    func showData(post:PostModel, postArray:NSMutableArray) {
        titleLabel.text = post.title
        descriptionText.text = post.desc
        authorLabel.setTitle(post.author, for: .normal)
        countOneLabel.text = String(post.resultOne)
        countTwoLabel.text = String(post.resultTwo)
        resultOneBar.progress = Float(post.resultOne)/Float((post.resultOne+post.resultTwo))
        resultTwoBar.progress = Float(post.resultTwo)/Float((post.resultOne+post.resultTwo))
        createdLabel.text = dateFromStringConverter(date: post.created)
        
        photoOneImage.image = showImage(urlImage: postObject.imageOne)
        photoTwoImage.image = showImage(urlImage: postObject.imageOne)
    }
    
    func dateFromStringConverter(date: String)-> String {
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        //Specify Format of String to Parse
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        //Parse into NSDate
        let dateFromString : NSDate = dateFormatter.date(from: date)! as NSDate
        
        dateFormatter.dateFormat = "dd-MM-yyyy' 'HH:mm:ss"
        let dateString = dateFormatter.string(from:dateFromString as Date)
        
        return dateString
    }
    
    func dateFromStringConverterShort(date: String)-> NSDate? {
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        //Specify Format of String to Parse
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        //Parse into NSDate
        let dateFromString : NSDate = dateFormatter.date(from: date)! as NSDate
        
        return dateFromString
    }
    
    func updateVotes(postId: NSInteger) {
        Alamofire.request("http://127.0.0.1:8000/api/posts/\(postId)/", method: .get, encoding: URLEncoding.default, headers: self.headers).responseJSON { response in
            if let JSON = response.result.value as? [String: Any] {
                let countOne = JSON["result1"] as! NSInteger
                let countTwo = JSON["result2"] as! NSInteger
                self.countOneLabel.text = String(countOne)
                self.countTwoLabel.text = String(countTwo)
                
                self.resultOneBar.progress = Float(countOne)/Float((countOne+countTwo))
                self.resultTwoBar.progress = Float(countTwo)/Float((countOne+countTwo))
            }
        }
    }

    @IBAction func chooseOne(_ sender: Any) {
        let parameters: Parameters = [
            "result1" : postObject.resultOne+1,
            ]
        
        Alamofire.request("http://127.0.0.1:8000/api/posts/\(postObject.id!)/", method: .patch, parameters:parameters, encoding: URLEncoding.default, headers: self.headers).responseJSON { response in
            self.updateVotes(postId: self.postObject.id)
            
            let parameters: Parameters = [
                "points" : self.points+1,
                ]
            Alamofire.request("http://127.0.0.1:8000/users/current/", method: .get, encoding: URLEncoding.default, headers: self.headers).responseJSON { response in
                if let JSON = response.result.value as? [String: Any] {
                    let userId = JSON["id"] as? NSInteger
                    let urlProfile = "http://127.0.0.1:8000/api/userprofile/\(String(describing: userId!))/"
                    
                    Alamofire.request(urlProfile, method: .patch, parameters:parameters, encoding: URLEncoding.default, headers: self.headers).responseJSON { response in

                    }
                }
            }
        }
    }
    
    @IBAction func chooseTwo(_ sender: Any) {
        let parameters: Parameters = [
            "result2" : postObject.resultOne+1,
            ]
        
        Alamofire.request("http://127.0.0.1:8000/api/posts/\(postObject.id!)/", method: .patch, parameters:parameters, encoding: URLEncoding.default, headers: self.headers).responseJSON { response in
            self.updateVotes(postId: self.postObject.id)
            
            let parameters: Parameters = [
                "points" : self.points+1,
                ]
            Alamofire.request("http://127.0.0.1:8000/users/current/", method: .patch, parameters:parameters, encoding: URLEncoding.default, headers: self.headers).responseJSON { response in
                if let JSON = response.result.value as? [String: Any] {
                    let userId = JSON["id"] as? NSInteger
                    let urlProfile = "http://127.0.0.1:8000/api/userprofile/\(String(describing: userId!))/"
                    
                    Alamofire.request(urlProfile, method: .patch, parameters:parameters, encoding: URLEncoding.default, headers: self.headers).responseJSON { response in
                        
                    }
                }
            }
        }
    }
    
    func loadComments() {
        Alamofire.request("http://127.0.0.1:8000/api/posts/\(String(self.idPost))/", method: .get, encoding: URLEncoding.default, headers: self.headers).responseJSON { response in
            if let JSON = response.result.value as? [String: Any] {
                let commentArray = JSON["comments"] as! NSArray
                for commentItems in commentArray {
                    Alamofire.request("\(commentItems)", method: .get, encoding: URLEncoding.default, headers: self.headers).responseJSON { response in
                        if let JSON = response.result.value as? [String: Any] {
                            self.idArr.add(JSON["id"] as Any)
                            self.commentArr.add(JSON["comment"] as Any)
                            self.createdArr.add(JSON["created"] as Any)
                            
                            let user = JSON["user"] as! String
                            let userString = String(describing: user)
                            
                            Alamofire.request("\(userString)", method: .get, encoding: URLEncoding.default, headers: self.headers).responseJSON { response in
                                if let JSON = response.result.value as? [String: Any] {
                                    self.usernameArr.add(JSON["username"] as Any)
                                                                        
                                    let userId = JSON["id"] as! NSInteger
                                    let userIdString = String(describing: userId)
                                    
                                    Alamofire.request("http://127.0.0.1:8000/api/userprofile/\(userIdString)/", method: .get, encoding: URLEncoding.default, headers: self.headers).responseJSON { response in
                                        if let JSON = response.result.value as? [String: Any] {
                                            self.avatarArr.add(JSON["avatar"] as Any)
                                            
                                            self.countComment = self.countComment+1
                                            self.tableView.reloadData()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countComment
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentTableViewCell
        // Configure the cell...
        
        cell.usernameLabel?.text = self.usernameArr[indexPath.row] as? String
        cell.commentText?.text = self.commentArr[indexPath.row] as? String
        cell.avatarImage.image = showImage(urlImage: avatarArr[indexPath.row] as! String)
        
        //format date and time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy' 'HH:mm:ss"
        
        let stringToDate = dateFromStringConverterShort(date: createdArr[indexPath.row] as! String)
        let dateString = dateFormatter.string(from:stringToDate! as Date)
        cell.createdLabel.text = dateString
        
        return cell
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
