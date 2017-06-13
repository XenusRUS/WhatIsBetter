//
//  CouponTableViewController.swift
//  WhatIsBetter
//
//  Created by admin on 07.05.17.
//  Copyright © 2017 vadim. All rights reserved.
//

import UIKit
import SideMenu
import Alamofire
import KeychainSwift

class CouponTableViewController: UITableViewController {
    var count = 0
    var idArr: NSMutableArray = []
    var nameArr: NSMutableArray = []
    var imageArr: NSMutableArray = []
    var descriptionArr: NSMutableArray = []

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor(red: 164.0/255.0, green: 205.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        tabBarController?.tabBar.tintColor = UIColor(red: 164.0/255.0, green: 205.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        setupSideMenu()
        let nibName = UINib(nibName: "CouponTableViewCell", bundle:nil)
        self.tableView.register(nibName, forCellReuseIdentifier: "CouponTableViewCell")
        tableView.register(UINib(nibName: "CouponTableViewCell", bundle:nil), forCellReuseIdentifier: "CouponTableViewCell")
        
        setupSideMenu()
        getData()
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
    
    @IBAction fileprivate func changeSwitch(_ switchControl: UISwitch) {
        SideMenuManager.menuFadeStatusBar = switchControl.isOn
    }
    
    func getData() {
        let headers: HTTPHeaders = [
            "Authorization": "Token \(KeychainSwift().get("token")!)",
        ]
        
        Alamofire.request("http://127.0.0.1:8000/api/coupons/", method: .get, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            
            if let JSON = response.result.value as? [String: Any] {
                self.count = JSON["count"] as! NSInteger
                for items in JSON["results"] as! NSArray {
                    let itms = items as? [String:Any]
                    
                    self.idArr.add(itms?["id"] as Any)
                    self.nameArr.add(itms?["name"] as Any)
                    self.imageArr.add(itms?["image"] as Any)
                    self.descriptionArr.add(itms?["description"] as Any)
                }
                
                Alamofire.request("http://127.0.0.1:8000/users/current/", method: .get, encoding: URLEncoding.default, headers: headers).responseJSON { response in
                    if let JSON = response.result.value as? [String: Any] {
                        let userId = JSON["id"] as? NSInteger
                        let urlProfile = "http://127.0.0.1:8000/api/userprofile/\(String(describing: userId!))/"
                        
                        Alamofire.request(urlProfile, method: .get, encoding: URLEncoding.default, headers: headers).responseJSON { response in
                            
                        }
                    }
                    self.tableView.reloadData()
                }
                self.tableView.reloadData()
            }
            
        }
    }
    
    func getImage(ImageUrl:String, imageView:UIImageView) -> UIImage {
        let strurl = URL(string: ImageUrl)
        let dtinternet = try? Data(contentsOf: strurl!)
        imageView.image = UIImage(data: dtinternet!)
        
        return imageView.image!
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "couponCell", for: indexPath) as! CouponTableViewCell
        // Configure the cell...
        
        cell.nameCoupon?.text = self.nameArr[indexPath.row] as? String
        cell.imageCoupon.image = getImage(ImageUrl: imageArr[indexPath.row] as! String, imageView: cell.imageCoupon)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CouponDetailViewController {
            let selectedRow = tableView.indexPathForSelectedRow!.row
            destination.idCoupon = idArr[selectedRow] as! NSInteger
            destination.nameCoupon = nameArr[selectedRow] as! String
            destination.imageCoupon = imageArr[selectedRow] as! String
            destination.descriptionCoupon = descriptionArr[selectedRow] as! String
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
