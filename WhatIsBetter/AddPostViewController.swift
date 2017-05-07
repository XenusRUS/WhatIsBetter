//
//  AddPostViewController.swift
//  WhatIsBetter
//
//  Created by admin on 27.04.17.
//  Copyright © 2017 vadim. All rights reserved.
//

import UIKit
import SideMenu
import Alamofire
import KeychainSwift

class AddPostViewController: UIViewController {
    @IBOutlet weak var namePost: UITextField!
    @IBOutlet weak var photoOnePost: UIImageView!
    @IBOutlet weak var photoTwoPost: UIImageView!
    @IBOutlet weak var descriptionPost: UITextView!
    
    var authorPost:String!
    var currentUser:String!
    var points: NSInteger!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupSideMenu()
        
        let headers: HTTPHeaders = [
            "Authorization": "Token \(KeychainSwift().get("token")!)",
        ]
        
        Alamofire.request("http://127.0.0.1:8000/users/current/", method: .get, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            if let JSON = response.result.value as? [String: Any] {
                print("JSON: \(JSON)")
                print("____cur_______")
                self.currentUser = JSON["url"] as! String
            }
        }
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
    
    @IBAction func selectImageOne(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "Choose your source", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            print("Camera selected")
            //Code for Camera
            //cameraf
            let picker = UIImagePickerController()
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                
                picker.allowsEditing = false
                picker.sourceType = UIImagePickerControllerSourceType.camera
                picker.cameraCaptureMode = .photo
                picker.modalPresentationStyle = .fullScreen
                self.present(picker,animated: true,completion: nil)
            } else {
                print("camera fail")
            }
        })
        alert.addAction(UIAlertAction(title: "Photo library", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            print("Photo selected")
            //Code for Photo library
            //photolibaryss
            let picker = UIImagePickerController()
            picker.allowsEditing = false
            picker.sourceType = .photoLibrary
            picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            picker.modalPresentationStyle = .popover
            self.present(picker, animated: true, completion: nil)
            picker.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func selectImageTwo(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }

    @IBAction func confirmButton(_ sender: Any) {
        let headers: HTTPHeaders = [
            "Authorization": "Token \(KeychainSwift().get("token")!)",
        ]
        
        let parameters: Parameters = [
            "name" : namePost.text!,
            "description" : descriptionPost.text!,
            "author": self.currentUser,
            ]
        
            let imageData1 = UIImageJPEGRepresentation(photoOnePost.image!, 0.5)!
            let imageData2 = UIImageJPEGRepresentation(photoTwoPost.image!, 0.5)!
        
            Alamofire.upload(multipartFormData: { multipartFormData in
        
                for (key, value) in parameters {
                    if let data = (value as AnyObject).data(using: String.Encoding.utf8.rawValue) {
                        multipartFormData.append(data, withName: key)
                    }
                }
    
                multipartFormData.append(imageData1, withName: "photo1", fileName: "image1.gif", mimeType: "image/gif")
                multipartFormData.append(imageData2, withName: "photo2", fileName: "image2.gif", mimeType: "image/gif")
        
            }, to: "http://127.0.0.1:8000/api/posts/", headers:headers, encodingCompletion: { encodingResult in
                    switch encodingResult {
                        case .success(let upload, _, _):
                        upload
                        .validate()
                        .responseJSON { response in
                            switch response.result {
                                case .success(let value):
                                    //
                                    let parameters: Parameters = [
                                        "points" : self.points+4,
                                        ]
                                    Alamofire.request("http://127.0.0.1:8000/users/current/", method: .patch, parameters:parameters, encoding: URLEncoding.default, headers: headers).responseJSON { response in
                                        if let JSON = response.result.value as? [String: Any] {
                                            let userId = JSON["id"] as? NSInteger
                                            let urlProfile = "http://127.0.0.1:8000/api/userprofile/\(String(describing: userId!))/"
                                            
                                            Alamofire.request(urlProfile, method: .patch, parameters:parameters, encoding: URLEncoding.default, headers: headers).responseJSON { response in
                                                
                                            }
                                        }
                                    }
                                    //
                                    print("responseObject: \(value)")
                                case .failure(let responseError):
                                    print("responseError: \(responseError)")
                            }
                        }
                                case .failure(let encodingError):
                                        print("encodingError: \(encodingError)")
                        }
            })
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
