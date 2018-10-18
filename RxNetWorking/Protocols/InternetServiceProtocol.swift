//
//  InternetServiceProtocol.swift
//  RxNetWorking
//
//  Created by Jun Dang on 2018-09-23.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import Foundation
import RxSwift

protocol InternetServiceProtocol {
    static func searchImageURL(searchText: String) -> Observable<Result<NSURL, Error>>
    static func sendRequest(resultNSURL: Result<NSURL, Error>) -> Observable<Result<Data, Error>>
    static func getImage(resultNSURL: Result<NSURL, Error>, cache: ImageDataCachingProtocol.Type) -> Observable<Result<UIImage, Error>>
}
   
