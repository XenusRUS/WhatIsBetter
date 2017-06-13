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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func auth(url:String, login: String, password: String) {
        let parameters: Parameters = [
            "username" : login,
            "password" : password,
        ]
        
        Alamofire.request(url, method: .post, parameters:parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let JSON = response.result.value as? [String: Any] {
                let token = JSON["token"] as! String
                
                let keychain = KeychainSwift()
                keychain.set(token, forKey: "token")
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "naviFeed")
                self.present(controller, animated: true, completion: nil)
                
            }
        }
    }
    
//    class func getNews(univers: [NSDictionary], login:String, password:String, completionHandler:@escaping (Any?)->(Void)) {
////        var news: [News] = []
//        
////        let parameters : Parameters = ["start":start, "count":count]
//        let parameters: Parameters = [
//            "username" : login,
//            "password" : password,
//            ]
//        
//        DataManager.request(url: "/api/university/news", parameters: parameters) { (dict, result, error_text, code) in
//            switch result {
//            case .success:
//                if let data = dict?.value(forKey: "") as? [NSDictionary] {
//                    if data.count == 0 { completionHandler(nil) }
//                    for i in 0..<data.count {
//                        let new = News.init(date: data[i].value(forKey: "date") as! String, title: data[i].value(forKey: "title") as! String, text: data[i].value(forKey: "text") as! String, imageUrl: data[i].value(forKey: "image") as! String, id: data[i].value(forKey: "id") as! Int, univerShort: "")
//                        news.append(new)
//                    }
//                    completionHandler(news)
//                }
//            case .error:
//                completionHandler(nil)
//            case .invalidToken: break
//            case .noInternetConnection: break
//            }
//        }
//    }
    
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
            let url = "http://127.0.0.1:8000/api-token-auth/"
            
            auth(url: url, login: emailField.text!, password: passwordField.text!)
        }

    }
    

    @IBAction func registrationButton(_ sender: Any) {
    }

}

