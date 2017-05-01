//
//  ProfileViewControlller.swift
//  WhatIsBetter
//
//  Created by admin on 18.02.17.
//  Copyright © 2017 vadim. All rights reserved.
//

import UIKit
import KeychainSwift

class ProfileViewControlller: ViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBAction fileprivate func close() {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        avatarImageView.layer.cornerRadius = 75;
        avatarImageView.layer.masksToBounds = true;
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
