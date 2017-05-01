//
//  FeedTableViewController.swift
//  WhatIsBetter
//
//  Created by admin on 21.02.17.
//  Copyright © 2017 vadim. All rights reserved.
//

import UIKit
import SideMenu
import Alamofire
import KeychainSwift

class FeedTableViewController: UITableViewController {
    var count = 0
    var idArr: NSMutableArray = []
    var nameArr: NSMutableArray = []
    var descriptionArr: NSMutableArray = []
    var photoOneArr: NSMutableArray = []
    var photoTwoArr: NSMutableArray = []
    var resultOneArr: NSMutableArray = []
    var resultTwoArr: NSMutableArray = []
    var createdArr: NSMutableArray = []
    var authorArr: NSMutableArray = []

    override func viewDidLoad() {
        super.viewDidLoad()
        print(KeychainSwift().get("token")!)
        print("yaibal")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        setupSideMenu()
        let nibName = UINib(nibName: "PostFeedTableViewCell", bundle:nil)
        self.tableView.register(nibName, forCellReuseIdentifier: "PostFeedTableViewCell")
        tableView.register(UINib(nibName: "PostFeedTableViewCell", bundle:nil), forCellReuseIdentifier: "PostFeedTableViewCell")
        
        getData()
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
    
    func getData() {
        let headers: HTTPHeaders = [
            "Authorization": "Token \(KeychainSwift().get("token")!)",
        ]
        
        Alamofire.request("http://127.0.0.1:8000/api/posts/", method: .get, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            
            if let JSON = response.result.value as? [String: Any] {
                print("JSON: \(JSON)")
                print("___________")
                
                self.count = JSON["count"] as! NSInteger
                for items in JSON["results"] as! NSArray {
                    let itms = items as? [String:Any]
                    
                    self.idArr.add(itms?["id"] as Any)
                    self.nameArr.add(itms?["name"] as Any)
                    self.descriptionArr.add(itms?["description"] as Any)
                    self.photoOneArr.add(itms?["photo1"] as Any)
                    self.photoTwoArr.add(itms?["photo2"] as Any)
                    self.resultOneArr.add(itms?["result1"] as Any)
                    self.resultTwoArr.add(itms?["result2"] as Any)
                    self.createdArr.add(itms?["created"] as Any)
                    
                    let authorLink = itms?["author"] as! NSString
                    Alamofire.request("\(authorLink)", method: .get, encoding: URLEncoding.default, headers: headers).responseJSON { response in
                        if let JSON = response.result.value as? [String: Any] {
                            print("JSON: \(JSON)")
                            print("____kok_______")
                            
                            self.authorArr.add(JSON["username"] as Any)
                        }
                    }
                }
                self.tableView.reloadData()
            }
            
        }
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

        cell.postNameLabel?.text = self.nameArr[indexPath.row] as? String
        
        let strurl1 = URL(string: photoOneArr[indexPath.row] as! String)
        let dtinternet1 = try? Data(contentsOf: strurl1!)
        cell.imageOne.image = UIImage(data: dtinternet1!)
        
        let strurl2 = URL(string: photoTwoArr[indexPath.row] as! String)
        let dtinternet2 = try? Data(contentsOf: strurl2!)
        cell.imageTwo.image = UIImage(data: dtinternet2!)

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PostViewController {
            let selectedRow = tableView.indexPathForSelectedRow!.row
            destination.idPost = idArr[selectedRow] as! NSInteger
            destination.namePost = nameArr[selectedRow] as! String
            destination.createdPost = createdArr[selectedRow] as! String
            destination.descriptionPost = descriptionArr[selectedRow] as! String
            destination.photoOnePost = photoOneArr[selectedRow] as! String
            destination.photoTwoPost = photoTwoArr[selectedRow] as! String
            destination.resultOnePost = resultOneArr[selectedRow] as! NSInteger
            destination.resultTwoPost = resultTwoArr[selectedRow] as! NSInteger
            destination.authorPost = authorArr[selectedRow] as! String
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
