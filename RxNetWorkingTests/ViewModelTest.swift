//
//  ViewModelTest.swift
//  RxNetWorkingTests
//
//  Created by Jun Dang on 2018-09-26.
//  Copyright © 2018 Jun Dang. All rights reserved.
//


import XCTest
import RxSwift
import RxCocoa
import RxBlocking

@testable import RxNetWorking

class ViewModelTests: XCTestCase {
    let bag = DisposeBag()
    //1
    private func createViewModel(text: String) -> ViewModel {
        return ViewModel(searchText: text, apiType: MockInternetService.self, imageDataCacheType: ImageDataCaching.self)
    }
    //2
    func test_whenInitialized_storesInitParams() {
        let text = "toronto"
        let viewModel = createViewModel(text: text)
        
        XCTAssertNotNil(viewModel.searchText)
        XCTAssertNotNil(viewModel.apiType)
        XCTAssertNotNil(viewModel.imageDataCacheType)
    }
    //3
    func test_whenInit_callsBindToOutPut_FetchImage() {
        let text = "toronto"
        let viewModel = createViewModel(text: text)
        let flickrImageObservable = viewModel.flickrImageObservable
   
        DispatchQueue.main.async {
            MockInternetService.imageURLResult.onNext(Result<NSURL, Error>.Success(TestData.stubImageURL!))
            MockInternetService.imageDataResult.onNext(Result<Data, Error>.Success(TestData.stubFlickrImageData!))
        }
  
        let emitted = try! flickrImageObservable.take(1).toBlocking(timeout: 1).toArray()
        XCTAssertEqual(emitted[0].pngData(), TestData.stubFlickrImageData)
    }
}
