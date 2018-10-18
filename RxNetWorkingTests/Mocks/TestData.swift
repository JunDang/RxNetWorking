//
//  TestData.swift
//  RxNetWorkingTests
//
//  Created by Jun Dang on 2018-09-26.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import Foundation
import RxCocoa
import UIKit


@testable import RxNetWorking

class TestData {
    
    
    
    static let flickrResponseOnePhotoJSON: [String: Any] = [
        
        "photos":[
            "page": 1,
            "pages": 7,
            "perpage": 1,
            "total": 7,
            "photo":[
                [
                    "id":"32870792062",
                    "owner":"30711218@N00",
                    "secret":"8d9cceac93",
                    "server":"2148",
                    "farm":3,
                    "title":"Lake Ontario Solitude",
                    "ispublic":1,
                    "isfriend":0,
                    "isfamily":0
                ]
            ]
        ],
        "stat":"ok"
        
    ]
    static let stubImageURL = NSURL(string: "http://farm3.staticflickr.com/2148/32870792062_8d9cceac93_b.jpg")
    static let stubFlickrImageData = UIImage(named: "LakeOntarioSolitude")!.pngData()
    
    static let flickrResultZeroPhotoJSON: [String: Any] = [
        
        "photos":[
            "page":1,
            "pages":0,
            "perpage":1,
            "total":0,
            "photo":[
                
            ]
        ],
        "stat":"ok"
    ]
}
