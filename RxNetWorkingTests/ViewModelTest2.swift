//
//  ViewModelTest2.swift
//  RxNetWorkingTests
//
//  Created by Jun Dang on 2018-09-28.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

/*import XCTest
import RxSwift
import RxCocoa
import RxBlocking

@testable import RxNetWorking

class ViewModelTests: XCTestCase {
    
    private func createViewModel(text: String) -> ViewModel {
        return ViewModel(searchText: text, apiType: MockInternetService.self, imageDataCacheType: ImageDataCaching.self)
    }
    
    func test_whenInitialized_storesInitParams() {
        let text = "toronto"
        let viewModel = createViewModel(text: text)
        
        XCTAssertNotNil(viewModel.searchText)
        XCTAssertNotNil(viewModel.apiType)
        XCTAssertNotNil(viewModel.imageDataCacheType)
    }
    
    func test_whenInit_callsBindToBackgroundImage_FetchImage() {
        let text = "toronto"
        let viewModel = createViewModel(text: text)
        XCTAssertNil(viewModel.flickrImage.value, "flickrImage is not nil by default")
        
        let backgroundImage = viewModel.flickrImage.asObservable()
        
        DispatchQueue.main.async {
            MockInternetService.imageURLResult.onNext(Result<NSURL, Error>.Success(TestData.stubImageURL!))
            MockInternetService.imageDataResult.onNext(Result<Data, Error>.Success(TestData.stubFlickrImageData!))
        }
        
        let emitted = try! backgroundImage.take(2).toBlocking(timeout: 1).toArray()
        XCTAssertNil(emitted[0])
        //XCTAssertEqual(emitted[0]!.pngData(), UIImage(named: "banff")!.pngData())
        XCTAssertEqual(emitted[1]!.pngData(), TestData.stubFlickrImageData)
    }
}*/
