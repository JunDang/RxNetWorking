//
//  MockInternetService.swift
//  RxNetWorkingTests
//
//  Created by Jun Dang on 2018-09-26.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa

@testable import RxNetWorking

class MockInternetService: InternetServiceProtocol {
    //1
    static var imageURLResult = PublishSubject<Result<NSURL, Error>>()
    static var imageDataResult = PublishSubject<Result<Data, Error>>()
    static var imageResult = PublishSubject<Result<UIImage, Error>>()
    //2
    static func searchImageURL(searchText: String) -> Observable<Result<NSURL, Error>> {
        return imageURLResult.asObservable()
    }
    //3
    static func sendRequest(resultNSURL: Result<NSURL, Error>) -> Observable<Result<Data, Error>> {
        return imageDataResult.asObservable()
    }
    //4
    static func getImage(resultNSURL: Result<NSURL, Error>, cache: ImageDataCachingProtocol.Type) -> Observable<Result<UIImage, Error>> {
        switch resultNSURL {
        case .Success:
            return self.sendRequest(resultNSURL:resultNSURL)
                .map() {(imageDataResult) in
                    switch imageDataResult {
                    case .Success(let imageData):
                        let imageFromRequest = UIImage(data: imageData as Data)
                        return Result<UIImage, Error>.Success(imageFromRequest!)
                    case .Failure(let error):
                        return Result<UIImage, Error>.Failure(error)
                    }
            }
        case .Failure(let error):
            return Observable.just(Result<UIImage, Error>.Failure(error))
        }
    }
}

