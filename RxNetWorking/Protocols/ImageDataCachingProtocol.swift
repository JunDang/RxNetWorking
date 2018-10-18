//
//  ImageDataCachingProtocol.swift
//  RxNetWorking
//
//  Created by Jun Dang on 2018-09-23.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import Foundation
import UIKit

protocol ImageDataCachingProtocol {
    static var imageDataCache:  NSCache<AnyObject, AnyObject> { get }
    static func saveImageDataToCache(data: NSData?, url: NSURL)
    static func imageDataFromURLFromChache(url: NSURL) -> NSData?
}
