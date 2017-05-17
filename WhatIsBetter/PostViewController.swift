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
    var idPost: NSInteger!
    var namePost: String!
    var descriptionPost: String!
    var authorPost: String!
    var photoOnePost: String!
    var photoTwoPost: String!
    var resultOnePost: NSInteger!
    var resultTwoPost: NSInteger!
    var createdPost: String!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        loadComments()
        
        tableView.delegate = self
        tableView.dataSource = self as? UITableViewDataSource
        
        setupSideMenu()
        showData()
        
//        addCommentTextView.text = "Ваше сообщение"
//        addCommentTextView.textColor = UIColor.lightGray
        
//        let gradient: CAGradientLayer = CAGradientLayer()
//
//        gradient.colors = [UIColor.gray.cgColor, UIColor.purple.cgColor]
//        gradient.locations = [0.0 , 1.0]
//        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
//        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
//        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
//        
//        self.view.layer.insertSublayer(gradient, at: 0)
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
    
    func showData() {
        titleLabel.text = namePost
        descriptionText.text = descriptionPost
        authorLabel.setTitle(authorPost, for: .normal)
        countOneLabel.text = String(resultOnePost)
        countTwoLabel.text = String(resultTwoPost)
        resultOneBar.progress = Float(resultOnePost)/Float((resultOnePost+resultTwoPost))
        resultTwoBar.progress = Float(resultTwoPost)/Float((resultOnePost+resultTwoPost))
        
        //format date and time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy' 'HH:mm:ss"
        
        let stringToDate = dateFromStringConverter(date: createdPost)
        let dateString = dateFormatter.string(from:stringToDate! as Date)
        createdLabel.text = dateString
        
        //image 1
        let strurl1 = URL(string: photoOnePost!)
        let dtinternet1 = try? Data(contentsOf: strurl1!)
        photoOneImage.image = UIImage(data: dtinternet1!)
        
        //image 2
        let strurl2 = URL(string: photoTwoPost!)
        let dtinternet2 = try? Data(contentsOf: strurl2!)
        photoTwoImage.image = UIImage(data: dtinternet2!)
    }
    
    func dateFromStringConverter(date: String)-> NSDate? {
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        //Specify Format of String to Parse
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ" //or you can use "yyyy-MM-dd'T'HH:mm:ssX"
        //Parse into NSDate
        let dateFromString : NSDate = dateFormatter.date(from: date)! as NSDate
        
        return dateFromString
    }
    
    func dateFromStringConverterShort(date: String)-> NSDate? {
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        //Specify Format of String to Parse
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" //or you can use "yyyy-MM-dd'T'HH:mm:ssX"
        //Parse into NSDate
        let dateFromString : NSDate = dateFormatter.date(from: date)! as NSDate
        
        return dateFromString
    }
    
    @IBAction func addTest(_ sender: Any) {
        
    }

    @IBAction func chooseOne(_ sender: Any) {
        let headers: HTTPHeaders = [
            "Authorization": "Token \(KeychainSwift().get("token")!)",
        ]
        
        let parameters: Parameters = [
            "result1" : resultOnePost+1,
            ]
        
        Alamofire.request("http://127.0.0.1:8000/api/posts/\(idPost!)/", method: .patch, parameters:parameters, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            Alamofire.request("http://127.0.0.1:8000/api/posts/\(self.idPost!)/", method: .get, parameters:parameters, encoding: URLEncoding.default, headers: headers).responseJSON { response in
                if let JSON = response.result.value as? [String: Any] {
                    let countOne = JSON["result1"] as! NSInteger
                    let countTwo = JSON["result2"] as! NSInteger
                    self.countOneLabel.text = String(countOne)
                    self.countTwoLabel.text = String(countTwo)
                    
                    self.resultOneBar.progress = Float(countOne)/Float((countOne+countTwo))
                    self.resultTwoBar.progress = Float(countTwo)/Float((countOne+countTwo))
                }
            }
            
            let parameters: Parameters = [
                "points" : self.points+1,
                ]
            Alamofire.request("http://127.0.0.1:8000/users/current/", method: .get, encoding: URLEncoding.default, headers: headers).responseJSON { response in
                if let JSON = response.result.value as? [String: Any] {
                    let userId = JSON["id"] as? NSInteger
                    let urlProfile = "http://127.0.0.1:8000/api/userprofile/\(String(describing: userId!))/"
                    
                    Alamofire.request(urlProfile, method: .patch, parameters:parameters, encoding: URLEncoding.default, headers: headers).responseJSON { response in

                    }
                }
            }
        }
    }
    
    @IBAction func chooseTwo(_ sender: Any) {
        let headers: HTTPHeaders = [
            "Authorization": "Token \(KeychainSwift().get("token")!)",
        ]
        
        let parameters: Parameters = [
            "result2" : resultTwoPost+1,
            ]
        
        Alamofire.request("http://127.0.0.1:8000/api/posts/\(idPost!)/", method: .patch, parameters:parameters, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            Alamofire.request("http://127.0.0.1:8000/api/posts/\(self.idPost!)/", method: .get, parameters:parameters, encoding: URLEncoding.default, headers: headers).responseJSON { response in
                if let JSON = response.result.value as? [String: Any] {
                    let countOne = JSON["result1"] as! NSInteger
                    let countTwo = JSON["result2"] as! NSInteger
                    self.countOneLabel.text = String(countOne)
                    self.countTwoLabel.text = String(countTwo)
                    
                    self.resultOneBar.progress = Float(countOne)/Float((countOne+countTwo))
                    self.resultTwoBar.progress = Float(countTwo)/Float((countOne+countTwo))
                }
            }
            
            let parameters: Parameters = [
                "points" : self.points+1,
                ]
            Alamofire.request("http://127.0.0.1:8000/users/current/", method: .patch, parameters:parameters, encoding: URLEncoding.default, headers: headers).responseJSON { response in
                if let JSON = response.result.value as? [String: Any] {
                    let userId = JSON["id"] as? NSInteger
                    let urlProfile = "http://127.0.0.1:8000/api/userprofile/\(String(describing: userId!))/"
                    
                    Alamofire.request(urlProfile, method: .patch, parameters:parameters, encoding: URLEncoding.default, headers: headers).responseJSON { response in
                        
                    }
                }
            }
        }
    }
    
    func loadComments() {
        let headers: HTTPHeaders = [
            "Authorization": "Token \(KeychainSwift().get("token")!)",
        ]
        
        Alamofire.request("http://127.0.0.1:8000/api/posts/\(String(self.idPost))/", method: .get, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            if let JSON = response.result.value as? [String: Any] {
                let commentArray = JSON["comments"] as! NSArray
                for commentItems in commentArray {
                    print(commentItems)
                    print("commentItems")
                    Alamofire.request("\(commentItems)", method: .get, encoding: URLEncoding.default, headers: headers).responseJSON { response in
                        if let JSON = response.result.value as? [String: Any] {
                            print("JSON: \(JSON)")
                            print("_____coup______")
                            self.idArr.add(JSON["id"] as Any)
                            self.commentArr.add(JSON["comment"] as Any)
                            self.createdArr.add(JSON["created"] as Any)
                            
                            let user = JSON["user"] as! String
                            let userString = String(describing: user)
                            
                            print(userString)
                            print("comment")
                            
                            Alamofire.request("\(userString)", method: .get, encoding: URLEncoding.default, headers: headers).responseJSON { response in
                                if let JSON = response.result.value as? [String: Any] {
                                    self.usernameArr.add(JSON["username"] as Any)
                                    
                                    self.tableView.reloadData()
                                    
                                    let userId = JSON["id"] as! NSInteger
                                    let userIdString = String(describing: userId)
                                    
                                    Alamofire.request("http://127.0.0.1:8000/api/userprofile/\(userIdString)/", method: .get, encoding: URLEncoding.default, headers: headers).responseJSON { response in
                                        if let JSON = response.result.value as? [String: Any] {
                                            self.avatarArr.add(JSON["avatar"] as Any)
                                            
                                            self.countComment = self.countComment+1
                                            self.tableView.reloadData()
                                        }
//                                        self.tableView.reloadData()
                                    }
                                    
                                    
                                    
                                }
//                                self.tableView.reloadData()
                            }
                            
//                            self.tableView.reloadData()
                        }
//                        self.tableView.reloadData()
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
//        cell.createdLabel?.text = self.createdArr[indexPath.row] as? String
        
        let strurl = URL(string: avatarArr[indexPath.row] as! String)
        let dtinternet = try? Data(contentsOf: strurl!)
        cell.avatarImage.image = UIImage(data: dtinternet!)
        
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
