//
//  ImageDataCaching.swift
//  RxNetWorking
//
//  Created by Jun Dang on 2018-09-23.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import Foundation
import UIKit

class ImageDataCaching: ImageDataCachingProtocol {
    //1
    static var imageDataCache = NSCache<AnyObject, AnyObject>()
    //2
    static func saveImageDataToCache(data: NSData?, url: NSURL) {
        if let data = data {
            imageDataCache.setObject(data, forKey: url)
        }
    }
    //3
    static func imageDataFromURLFromChache(url: NSURL) -> NSData? {
        return imageDataCache.object(forKey: url) as? NSData
    }
        
}
