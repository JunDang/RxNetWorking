//
//  UIImage+Extension.swift
//  RxNetWorking
//
//  Created by Jun Dang on 2018-09-24.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    func scaled(_ newSize: CGSize) -> UIImage? {
        guard size != newSize else {
            return self
        }
        
        let ratio = max(newSize.width / (size.width), newSize.height / (size.height))
        let width = size.width * ratio
        let height = size.height * ratio
        
        let scaledRect = CGRect(
            x: (newSize.width - width) / 2.0,
            y: (newSize.height - height) / 2.0,
            width: width, height: height)
        
        UIGraphicsBeginImageContextWithOptions(scaledRect.size, false, 0.0);
        defer { UIGraphicsEndImageContext() }
        
        self.draw(in: scaledRect)
        
        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }
}
