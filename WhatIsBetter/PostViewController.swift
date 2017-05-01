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

class PostViewController: UIViewController {
    var idPost: NSInteger!
    var namePost: String!
    var descriptionPost: String!
    var authorPost: String!
    var photoOnePost: String!
    var photoTwoPost: String!
    var resultOnePost: NSInteger!
    var resultTwoPost: NSInteger!
    var createdPost: String!
    

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
        setupSideMenu()
        showData()
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
    
    @IBAction func addTest(_ sender: Any) {
        let headers: HTTPHeaders = [
            "Authorization": "Token \(KeychainSwift().get("token")!)",
        ]
        
        let parameters: Parameters = [
            "result1" : resultOnePost+1,
        ]
        
        Alamofire.request("http://127.0.0.1:8000/api/posts/\(idPost!)/", method: .patch, parameters:parameters, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            debugPrint(response)
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
