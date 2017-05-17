//
//  CouponDetailViewController.swift
//  WhatIsBetter
//
//  Created by admin on 07.05.17.
//  Copyright © 2017 vadim. All rights reserved.
//

import UIKit
import SideMenu
import Alamofire
import KeychainSwift

class CouponDetailViewController: UIViewController {
    var idCoupon: NSInteger!
    var nameCoupon: String!
    var imageCoupon: String!
    var descriptionCoupon: String!
    
    @IBOutlet weak var nameCouponLabel: UILabel!
    @IBOutlet weak var couponImageView: UIImageView!
    @IBOutlet weak var descriptionCouponTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        showData()
        setupSideMenu()
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
        nameCouponLabel.text = nameCoupon
        descriptionCouponTextView.text = descriptionCoupon
        
        let strurl = URL(string: imageCoupon!)
        let dtinternet = try? Data(contentsOf: strurl!)
        couponImageView.image = UIImage(data: dtinternet!)
    }
    
    @IBAction func buyButton(_ sender: Any) {
        let headers: HTTPHeaders = [
            "Authorization": "Token \(KeychainSwift().get("token")!)",
        ]
        
        let parameters: Parameters = [
            "coupons": "http://127.0.0.1:8000/api/coupons/\(String(describing: idCoupon!))/" as AnyObject,
            ]

        Alamofire.request("http://127.0.0.1:8000/users/current/", method: .get, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            if let JSON = response.result.value as? [String: Any] {
                let userId = JSON["id"] as? NSInteger
                let urlProfile = "http://127.0.0.1:8000/api/userprofile/\(String(describing: userId!))/"
                print(urlProfile)
                
                Alamofire.request(urlProfile, method: .put, parameters:parameters, encoding: URLEncoding.default, headers: headers).responseJSON { response in
                    let parameters: Parameters = [
                        "points" : -1,
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
        }
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
