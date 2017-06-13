//
//  HistoryTableViewController.swift
//  WhatIsBetter
//
//  Created by admin on 22.02.17.
//  Copyright © 2017 vadim. All rights reserved.
//

import UIKit
import SideMenu
import Alamofire
import KeychainSwift

class HistoryTableViewController: UITableViewController {
    var count = 0
//    var idArr: NSMutableArray = []
//    var nameArr: NSMutableArray = []
//    var descriptionArr: NSMutableArray = []
//    var photoOneArr: NSMutableArray = []
//    var photoTwoArr: NSMutableArray = []
//    var resultOneArr: NSMutableArray = []
//    var resultTwoArr: NSMutableArray = []
//    var createdArr: NSMutableArray = []
//    var authorArr: NSMutableArray = []
    var points: NSInteger!
    var currentId: NSInteger!
    var userId: NSInteger!
    
    var postObject : PostModel = PostModel()
    var postArray: NSMutableArray = []
    
    let postsUrl = "http://127.0.0.1:8000/api/posts/"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        let nibName = UINib(nibName: "PostFeedTableViewCell", bundle:nil)
        self.tableView.register(nibName, forCellReuseIdentifier: "PostFeedTableViewCell")
        
        tableView.register(UINib(nibName: "PostFeedTableViewCell", bundle:nil), forCellReuseIdentifier: "PostFeedTableViewCell")
        
        setupSideMenu()
        
        getData(post: postObject, postArray: postArray)
        self.tableView.reloadData()
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
    
    func getCurrentUser(url: String) {
        Alamofire.request(url, method: .get, encoding: URLEncoding.default, headers: self.headers).responseJSON { response in
            if let JSON = response.result.value as? [String: Any] {
                let userId = JSON["id"] as? NSInteger
                let urlProfile = "http://127.0.0.1:8000/api/userprofile/\(String(describing: userId!))/"
                
                Alamofire.request(urlProfile, method: .get, encoding: URLEncoding.default, headers: self.headers).responseJSON { response in
                    if let JSON = response.result.value as? [String: Any] {
                        self.points = JSON["points"] as! NSInteger
                    }
                }
            }
            self.tableView.reloadData()
        }
    }
    
    func getImage(ImageUrl:String, imageView:UIImageView) -> UIImage {
        let strurl = URL(string: ImageUrl)
        let dtinternet = try? Data(contentsOf: strurl!)
        imageView.image = UIImage(data: dtinternet!)
        
        return imageView.image!
    }
    
    func getData(post:PostModel, postArray:NSMutableArray) {
        Alamofire.request(postsUrl, method: .get, encoding: URLEncoding.default, headers: self.headers).responseJSON { response in
            
            if let JSON = response.result.value as? [String: Any] {
                
                self.count = JSON["count"] as! NSInteger
                for items in JSON["results"] as! NSArray {
                    let itms = items as? [String:Any]
                    
                    post.id = itms?["id"] as! NSInteger
                    post.title = itms?["name"] as! String
                    post.desc = itms?["description"] as! String
                    post.imageOne = itms?["photo1"] as! String
                    post.imageTwo = itms?["photo2"] as! String
                    post.resultOne = itms?["result1"] as! NSInteger
                    post.resultTwo = itms?["result2"] as! NSInteger
                    post.created = itms?["created"] as! String
                    
                    postArray.add(post)
                    
                    let authorLink = itms?["author"] as! NSString
                    Alamofire.request("\(authorLink)", method: .get, encoding: URLEncoding.default, headers: self.headers).responseJSON { response in
                        if let JSON = response.result.value as? [String: Any] {
                            post.author = JSON["author"] as! String
                        }
                    }
                }
                let urlCurrent = "http://127.0.0.1:8000/users/current/"
                self.getCurrentUser(url: urlCurrent)
            }
        }
    }
    
    @IBAction fileprivate func changeSwitch(_ switchControl: UISwitch) {
        SideMenuManager.menuFadeStatusBar = switchControl.isOn
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! PostFeedTableViewCell
        // Configure the cell...
        getData(post: self.postObject, postArray: postArray)
        
        let post = postArray[indexPath.row] as! PostModel
        
        cell.postNameLabel?.text = post.title
        cell.imageOne.image = getImage(ImageUrl: post.imageOne, imageView: cell.imageOne)
        cell.imageTwo.image = getImage(ImageUrl: post.imageTwo, imageView: cell.imageTwo)
        
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PostViewController {
            let selectedRow = tableView.indexPathForSelectedRow!.row
            destination.postObject = postArray[selectedRow] as! PostModel
            destination.points = points
        }
        if let destination2 = segue.destination as? AddPostViewController {
            destination2.points = points
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
