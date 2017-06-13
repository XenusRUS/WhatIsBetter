//
//  WhatIsBetterTests.swift
//  WhatIsBetterTests
//
//  Created by admin on 01.02.17.
//  Copyright © 2017 vadim. All rights reserved.
//

import XCTest
@testable import WhatIsBetter

class WhatIsBetterTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDateTimeConverter() {        
        let postVC = PostViewController()
        let convert = postVC.dateFromStringConverter(date: "2017-05-07T13:05:23.572639Z")
        
        XCTAssertEqual(convert, "07-05-2017 18:05:23")
        XCTAssertNotEqual(convert, "07-05-201718:05:23")
        XCTAssertNotEqual(convert, "2017-05-07T13:05:23.572639Z")
    }
    
    func testShowImage() {
        let postVC = PostViewController()
        let urlImage = "http://www.blindfiveyearold.com/wp-content/uploads/2011/01/homer-simpson-150x150.jpg"
        let imageView = postVC.showImage(urlImage: urlImage)
        
        XCTAssertNotNil(imageView)
    }
    
    func testCamera() {
        let addPostVC = AddPostViewController()
        let camera = addPostVC.isCamera()
        
        XCTAssertFalse(camera)
    }
    
    func testPhotoLibraryPicker() {
        let addPostVC = AddPostViewController()
        let picker = UIImagePickerController()
        let photoLibraryPicker = addPostVC.createPhotoLibraryPicker(picker: picker)
    
        XCTAssertNotNil(photoLibraryPicker)
    }
    
    func testImageLayer() {
        let profileVC = ProfileViewControlller()
        let imageView = UIImageView()
        let imageLayer = profileVC.imageLayer(imageView: imageView)
        
        XCTAssertNotNil(imageLayer)
    }
    
    func testEndOfWords() {
        let profileVC = ProfileViewControlller()
        
        XCTAssertFalse(profileVC.endOfWords(count: 5))
        XCTAssertFalse(profileVC.endOfWords(count: 11))
        XCTAssertFalse(profileVC.endOfWords(count: 17))
        XCTAssertTrue(profileVC.endOfWords(count: 3))
        XCTAssertTrue(profileVC.endOfWords(count: 21))
        XCTAssertTrue(profileVC.endOfWords(count: 134))
        XCTAssertFalse(profileVC.endOfWords(count: 0))
    }
    
    func testGetCouponImage() {
        let couponVC = CouponTableViewController()
        let imageView = UIImageView()
        let imageUrl = "http://www.blindfiveyearold.com/wp-content/uploads/2011/01/homer-simpson-150x150.jpg"
        let getImage = couponVC.getImage(ImageUrl:imageUrl, imageView:imageView)
        
        XCTAssertNotNil(getImage)
    }
    
    func testGetDetailCouponImage() {
        let couponDetailVC = CouponDetailViewController()
        let imageView = UIImageView()
        let imageUrl = "http://www.blindfiveyearold.com/wp-content/uploads/2011/01/homer-simpson-150x150.jpg"
        let getImage = couponDetailVC.getImage(ImageUrl:imageUrl, imageView:imageView)
        
        XCTAssertNotNil(getImage)
    }
    
    func testGetMyCouponImage() {
        let myCouponVC = MyCouponsTableViewController()
        let imageView = UIImageView()
        let imageUrl = "http://www.blindfiveyearold.com/wp-content/uploads/2011/01/homer-simpson-150x150.jpg"
        let getImage = myCouponVC.getImage(ImageUrl:imageUrl, imageView:imageView)
        
        XCTAssertNotNil(getImage)
    }
    
    func testImageCommentLayer() {
        let commentCell = CommentTableViewCell()
        let imageView = UIImageView()
        let layer = commentCell.imageLayer(imageView: imageView)
        
        XCTAssertNotNil(layer)
    }
    
    func testLeftViewRect() {
        let customTextField = CustomTextField()
        let leftViewRect = customTextField.leftViewRect(forBounds: CGRect.zero)
        
        XCTAssertEqual(leftViewRect, CGRect.zero)
    }
    
//    func testCameraPicker() {
//        let addPostVC = AddPostViewController()
//        let picker = UIImagePickerController()
//        let cameraPicker = addPostVC.createCameraPicker(picker: picker)
//        
//        XCTAssertNil(cameraPicker)
//    }
    
//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
