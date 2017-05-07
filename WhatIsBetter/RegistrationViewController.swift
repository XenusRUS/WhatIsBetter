//
//  RegistrationViewController.swift
//  WhatIsBetter
//
//  Created by admin on 15.02.17.
//  Copyright © 2017 vadim. All rights reserved.
//

import UIKit
import Alamofire
import KeychainSwift

class RegistrationViewController: UIViewController {
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var avatarImageView: UIImageView!

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        avatarImageView.layer.cornerRadius = 34.5;
        avatarImageView.layer.masksToBounds = true;

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func confirmButton(_ sender: Any) {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()

        
        if (emailTextField.text == "") || (passwordTextField.text == "") || (confirmPasswordTextField.text == "") || (usernameTextField.text == "") {
            let alertController = UIAlertController(title: "Внимание", message:"Все поля обязательны к заполнению!", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            activityIndicator.stopAnimating()
        }
        else {
            confirmRegistraion()
        }
        
//        if confirmPasswordTextField.text != passwordTextField.text {
//            let alertController = UIAlertController(title: "Пароли не совпадают!", message:"Подтвердите пароль", preferredStyle: UIAlertControllerStyle.alert)
//            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
//            self.present(alertController, animated: true, completion: nil)
//            activityIndicator.stopAnimating()
//            
//        } else {
//            confirmRegistraion()
//        }
    }
    
    func confirmRegistraion() {
        let parameters: [String: AnyObject] = [
            "username" : usernameTextField.text as AnyObject,
            "email" : emailTextField.text as AnyObject,
            "password" : passwordTextField.text as AnyObject,
            ]
        
        let parameters2: [String: AnyObject] = [
            "post_count" : 0 as AnyObject,
            ]
        
        let headers: HTTPHeaders = [
            "Authorization": "Token 5a710ba7007dbf9f9b600dc207775d8e57d97278",
        ]
        
        Alamofire.request("http://127.0.0.1:8000/users/", method: .post, parameters:parameters, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            Alamofire.request("http://127.0.0.1:8000/api/userprofile/", method: .post, parameters:parameters2, encoding: URLEncoding.default, headers: headers).responseJSON { response in

            }
        }
        
//        usernameTextField.text = ""
//        emailTextField.text = ""
//        passwordTextField.text = ""
//        confirmPasswordTextField.text = ""
        
//        let alertController = UIAlertController(title: "Регистрация завершена!", message:"Вы успешно зарегистрированы", preferredStyle: UIAlertControllerStyle.alert)
//        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
//        viewc.present(alertController, animated: true, completion: nil)
        activityIndicator.stopAnimating()
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
