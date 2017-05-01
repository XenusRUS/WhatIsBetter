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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
    
    @IBAction func confirmButton(_ sender: Any) {
        let headers: HTTPHeaders = [
            "Authorization": "Token \(KeychainSwift().get("token")!)",
        ]
        
        let parameters: Parameters = [
            "name" : namePost.text!,
//            "photo1" : "http://www.calvertgop.org/Darcey/images-misc/NoPicture.jpg",
//            "photo2" : "http://www.calvertgop.org/Darcey/images-misc/NoPicture.jpg",
            "description" : descriptionPost.text!,
            "result1" : 0,
            "result2" : 0,
            "author" : "http://127.0.0.1:8000/users/1/",
            ]
        
//        Alamofire.upload(multipartFormData: {
//            multipartFormData in
//            let imageData = UIImageJPEGRepresentation(self.photoOnePost.image!, 0.5)
//            let imageData2 = UIImageJPEGRepresentation(self.photoTwoPost.image!, 0.5)
//
//                multipartFormData.append(imageData!, withName: "photo1", fileName: "file.gif", mimeType: "image/gif")
//            multipartFormData.append(imageData2!, withName: "photo2", fileName: "file2.gif", mimeType: "image/gif")
////            }
////            if let imageData = UIImageJPEGRepresentation(self.photoOnePost.image!, 0.5){
////                multipartFormData.append(imageData, withName: "photo2", fileName: "file2.gif", mimeType: "image/gif")
////            }
//            
//            for (key,value) in parameters {
//                multipartFormData.append((value as AnyObject).data!, withName: key)
//            }
//        }, to: "http://127.0.0.1:8000/api/posts/", method: .post, headers: headers, encodingCompletion: { encodingResult in
//            switch encodingResult {
//            case .success(let upload,_,_):
//                upload.responseJSON { response in
//                    
//                    print(response.request)
//                    print(response.response)
//                    print(response.result)
//                    print(response.data)
//                }
//                break
//            case .failure(let encodingError):
//                print("error: \(encodingError)")
//                break
//            }
//        })
        
//        Alamofire.upload(multipartFormData: { multipartFormData in
//            if let imageData = UIImageJPEGRepresentation(self.photoOnePost.image!, 1) {
//                multipartFormData.append(imageData, withName: "file", fileName: "file.gif", mimeType: "image/gif")
//            }
//            
//            for (key, value) in parameters {
//                multipartFormData.append(((value as AnyObject).data)!, withName: key)
//            }}, to: "http://127.0.0.1:8000/api/posts/", method: .post, headers: headers,
//                encodingCompletion: { encodingResult in
//                    switch encodingResult {
//                    case .success(let upload, _, _):
//                        upload.response { [weak self] response in
//                            guard let strongSelf = self else {
//                                return
//                            }
//                            debugPrint(response)
//                        }
//                    case .failure(let encodingError):
//                        print("error:\(encodingError)")
//                    }
//        })
    
        
//        Alamofire.request("http://127.0.0.1:8000/api/posts/", method: .post, parameters:parameters, encoding: URLEncoding.default, headers: headers).responseJSON { response in
//            debugPrint(response)
//        }
//        
//        print("start upload")
//        
//        let parametersImage = [
//            "photo1": "no-image.gif",
//            "photo2": "no-image.gif",
//        ]
//        
//        Alamofire.upload(multipartFormData: { (multipartFormData) in
//            multipartFormData.append(UIImageJPEGRepresentation(self.photoOnePost.image!, 1)!, withName: "photo_path", fileName: "no-image.gif", mimeType: "image/gif")
//            for (key, value) in parametersImage {
//                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
//            }
//        }, to:"http://127.0.0.1:8000/media/")
//        { (result) in
//            switch result {
//            case .success(let upload, _, _):
//                
//                upload.uploadProgress(closure: { (progress) in
//                    //Print progress
//                })
//                
//                upload.responseJSON { response in
//                    //print response.result
//                }
//                
//            case .failure(let encodingError): break
//                //print encodingError.description
//            }
//        }
//        
//        print("end upload")
        
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
