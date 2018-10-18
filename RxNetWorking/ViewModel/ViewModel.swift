//
//  ViewModel.swift
//  RxNetWorking
//
//  Created by Jun Dang on 2018-09-23.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import RxCocoa
import RxSwift

class ViewModel {
    private let bag = DisposeBag()
    let apiType: InternetServiceProtocol.Type
    let imageDataCacheType: ImageDataCachingProtocol.Type
    
    // MARK: - Input
    let searchText: String
    
    // MARK: - Output
    var flickrImageObservable: Observable<UIImage> = Observable.just(UIImage(named: "banff")!)
    
    // MARK: - Init
    init(searchText: String, apiType: InternetServiceProtocol.Type, imageDataCacheType: ImageDataCachingProtocol.Type = ImageDataCaching.self) {
        self.searchText = searchText
        self.apiType = apiType
        self.imageDataCacheType = imageDataCacheType
        //1
        flickrImageObservable =  apiType
            .searchImageURL(searchText: searchText)
            .flatMap ({resultNSURL -> Observable<Result<UIImage, Error>> in
                return self.apiType.getImage(resultNSURL: resultNSURL, cache: self.imageDataCacheType)
            })
            //2
            .map() { result -> UIImage in
                switch result {
                case .Success(let image):
                    return image
                case .Failure:
                    return UIImage(named: "banff")!
                }
        }
   }
 }
