//
//  ViewController.swift
//  WhatIsBetter
//
//  Created by admin on 01.02.17.
//  Copyright © 2017 vadim. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let parameters: [String: AnyObject] = [
            "username" : "testiOS" as AnyObject,
            "email" : "iosclient@apple.com" as AnyObject,
            "password" : "1234" as AnyObject,
            ]
        
        Alamofire.request("http://127.0.0.1:8000/users/", method: .post, parameters:parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            print("original URL request", response.request)  // original URL request
            print("HTTP URL response", response.response) // HTTP URL response
            print("server data", response.data)     // server data
            print("result of serialization", response.result)   // result of response serialization
            
        
            
            if let JSON = response.result.value as? [String: Any] {
                print("JSON: \(JSON)")
                print("___________")
                
//                for results in JSON["results"] as! NSArray {
//                    let res = results as? [String:Any]
//                    let email = res?["email"] as! NSString
//                    let username = res?["username"] as! NSString
//                    let password = res?["password"] as! NSString
//                    
//                    print(email)
//                }
                
                let postEndpoint: String = "http://127.0.0.1:8000/users/?format=json"
                let url = URL(string: postEndpoint)!
                let session = URLSession.shared
                let postParams : [String: AnyObject] = ["username": "test2" as AnyObject, "password": "123" as AnyObject]
                let request = NSMutableURLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: postParams, options:  JSONSerialization.WritingOptions())
                    print(postParams)
                } catch {
                    print("bad things happened")
                }
                
                
            }
        }
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
        
        if emailField.text == "" {
            let alertController = UIAlertController(title: "Эл. почта не введена!", message:"Введите эл. почту", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            activityIndicator.stopAnimating()
        }
        if passwordField.text == "" {
            let alertController = UIAlertController(title: "Пароль не введен!", message:"Введите пароль", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            activityIndicator.stopAnimating()
        }
    }

    @IBAction func registrationButton(_ sender: Any) {
    }

}

