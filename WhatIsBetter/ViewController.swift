//
//  ViewController.swift
//  WhatIsBetter
//
//  Created by admin on 01.02.17.
//  Copyright © 2017 vadim. All rights reserved.
//

import UIKit
import Alamofire
import KeychainSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let headers: HTTPHeaders = [
            "Authorization": "Token 5a710ba7007dbf9f9b600dc207775d8e57d97278",
        ]
//        view.backgroundColor = UIColor.brownColor();
//        textField.text = "Some Text";
//        emailField.backgroundColor = UIColor.brown;
//        emailField.layer.borderWidth = 1.0;
//        emailField.layer.cornerRadius = 16.0;
////        emailField.leftView = UIView(frame: CGRectMake(0, 0, 5, 37));
//        emailField.leftViewMode = UITextFieldViewMode.always;
        
//        emailField.leftViewMode = UITextFieldViewMode.always
//        let loginImageView = UIImageView();
//        loginImageView.image = UIImage(named: "login.png")
//        emailField.leftView = loginImageView

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButton(_ sender: Any) {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        if (emailField.text == "") || (passwordField.text == "") {
            let alertController = UIAlertController(title: "Внимание", message:"Все поля обязательны к заполнению!", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            activityIndicator.stopAnimating()
        }
        else {
            let parameters: Parameters = [
                "username" : emailField.text!,
                "password" : passwordField.text!,
                ]
            
            Alamofire.request("http://127.0.0.1:8000/api-token-auth/", method: .post, parameters:parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                debugPrint(response)
                
                print("original URL request", response.request)  // original URL request
                print("HTTP URL response", response.response) // HTTP URL response
                print("server data", response.data)     // server data
                print("result of serialization", response.result)   // result of response serialization
                
                if let JSON = response.result.value as? [String: Any] {
                    print("JSON: \(JSON)")
                    print("____LOGIN_______")
                    
                    let token = JSON["token"] as! String
                    
                    print(token)
                    
                    let keychain = KeychainSwift()
                    keychain.set(token, forKey: "token")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "naviFeed")
                    self.present(controller, animated: true, completion: nil)
                }
            }
            
        }

    }
    

    @IBAction func registrationButton(_ sender: Any) {
    }

}

