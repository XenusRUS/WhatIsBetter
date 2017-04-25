//
//  PostViewController.swift
//  WhatIsBetter
//
//  Created by admin on 23.04.17.
//  Copyright © 2017 vadim. All rights reserved.
//

import UIKit
import SideMenu

class PostViewController: UIViewController {
    var namePost: String!
    var descriptionPost: String!
    var authorPost: String!
    var photoOnePost: String!
    var photoTwoPost: String!
    var resultOnePost: Float!
    var resultTwoPost: Float!
    var createdPost: String!
    

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var photoOneImage: UIImageView!
    @IBOutlet weak var photoTwoImage: UIImageView!
    @IBOutlet weak var authorLabel: UIButton!
    @IBOutlet weak var resultOneBar: UIProgressView!
    @IBOutlet weak var resultTwoBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        titleLabel.text = namePost
        createdLabel.text = createdPost
        descriptionText.text = descriptionPost
        authorLabel.setTitle(authorPost, for: .normal)
        resultOneBar.progress = resultOnePost/100
        resultTwoBar.progress = resultTwoPost/100
        
        let strurl1 = URL(string: photoOnePost!)
        let dtinternet1 = try? Data(contentsOf: strurl1!)
        photoOneImage.image = UIImage(data: dtinternet1!)
        
        let strurl2 = URL(string: photoTwoPost!)
        let dtinternet2 = try? Data(contentsOf: strurl2!)
        photoTwoImage.image = UIImage(data: dtinternet2!)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
