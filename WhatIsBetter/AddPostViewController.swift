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
        navigationController?.navigationBar.barTintColor = UIColor(red: 48.0/255.0, green: 64.0/255.0, blue: 86.0/255.0, alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 164.0/255.0, green: 205.0/255.0, blue: 255.0/255.0, alpha: 1.0)]
        navigationController?.navigationBar.tintColor = UIColor(red: 164.0/255.0, green: 205.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        
        // Do any additional setup after loading the view.
        setupSideMenu()
        
        descriptionPost.layer.borderColor = UIColor(red: 38/255, green: 51/255, blue: 70/255, alpha: 1.0).cgColor
        descriptionPost.layer.borderWidth = 0.5
        descriptionPost.layer.cornerRadius = 5
        
        let headers: HTTPHeaders = [
            "Authorization": "Token \(KeychainSwift().get("token")!)",
        ]
        
        Alamofire.request("http://127.0.0.1:8000/api/userprofile/1/", method: .get, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            if let JSON = response.result.value as? [String: Any] {
                let myPostsArray = JSON["posts"] as! NSArray
                let postsArr = myPostsArray.mutableCopy() as! NSMutableArray
                postsArr.add("http://127.0.0.1:8000/api/posts/21/")
                let postArray = ["http://127.0.0.1:8000/api/posts/20/", "http://127.0.0.1:8000/api/posts/21/"] as NSArray
                
                for postItems in postArray {
                let parameters: Parameters = [
                    "posts": postItems
                ]
                    Alamofire.request("http://127.0.0.1:8000/api/userprofile/1/", method: .patch, parameters:parameters, encoding: URLEncoding.default, headers: headers).responseJSON { response in
                        
                    }
                }
                
            }
        }
        
        Alamofire.request("http://127.0.0.1:8000/users/current/", method: .get, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            if let JSON = response.result.value as? [String: Any] {
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
    
    func isCamera() -> Bool {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            return true
        }
        else {
            return false
        }
    }
    
    func createCameraPicker(picker:UIImagePickerController) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerControllerSourceType.camera
        picker.cameraCaptureMode = .photo
        picker.modalPresentationStyle = .fullScreen
        
        return picker
    }
    
    func createPhotoLibraryPicker(picker:UIImagePickerController) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.modalPresentationStyle = .popover
        
        return picker
    }
    
    func showImage(urlImage: String) -> UIImage {
        let strurl1 = URL(string: urlImage)
        let dtinternet1 = try? Data(contentsOf: strurl1!)
        let imageView = UIImageView()
        imageView.image = UIImage(data: dtinternet1!)
        
        return imageView.image!
    }
    
    @IBAction func selectImageOne(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "Выберите источник", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Камера", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            print("Camera selected")
            //Code for Camera
            //camera
            if self.isCamera() {
                let picker = UIImagePickerController()
                let cameraPicker = self.createCameraPicker(picker: picker)
                self.present(cameraPicker,animated: true,completion: nil)
            } else {
                print("camera fail")
            }
        })
        alert.addAction(UIAlertAction(title: "Галерея", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            print("Photo selected")
            //Code for Photo library
            //photolibaryss
            let picker = UIImagePickerController()
            let photoLibraryPicker = self.createPhotoLibraryPicker(picker: picker)
            self.present(photoLibraryPicker, animated: true, completion: nil)
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
