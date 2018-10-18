//
//  InternetService.swift
//  RxNetWorking
//
//  Created by Jun Dang on 2018-09-23.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import RxSwift
import RxCocoa

enum Result<T, Error> {
    case Success(T)
    case Failure(Error)
}

// MARK: -Flickr URL Components
struct FlickrAPI {
    static let baseURLString = "https://api.flickr.com/services/rest/"
    static let apiKey = "5a45bd8e5e5a3424a42246944f98d7fd"
    static let searchMethod = "flickr.photos.search"
}

enum FlickrRequestError: Error {
    case unknown
    case emptyAlbum
}

class InternetService: InternetServiceProtocol {
    
    //MARK: - Flickr
    static func searchImageURL(searchText: String) -> Observable<Result<NSURL, Error>> {
        //1
        let baseURLString = FlickrAPI.baseURLString
        let parameters = [
            "method": FlickrAPI.searchMethod,
            "api_key": FlickrAPI.apiKey,
            "format": "json",
            "nojsoncallback": "1",
            "per_page": "25",
            "text": "\(searchText)",
            "group_id": "1463451@N25",
            "tagmode": "all"
        ]
        //2
        return request(baseURLString, parameters: parameters)
            .map({ result in
                switch result {
                case .Success(let data):
                    //3
                    var flickrModel: FlickrModel?
                    do {
                        flickrModel = try JSONDecoder().decode(FlickrModel.self, from: data)
                    } catch let parseError {
                        return Result<NSURL, Error>.Failure(parseError)
                    }
                    let flickrPhotos = flickrModel!.flickrModel!.flickrPhotos
                    //4
                    guard flickrPhotos.count > 0 else {
                        return Result<NSURL, Error>.Failure(FlickrRequestError.emptyAlbum)
                    }
                    //5
                    let randomIndex = Int(arc4random_uniform(UInt32(flickrPhotos.count)))
                    let photo = flickrPhotos[randomIndex]
                    let imageURL = photo.createImageURL()
                    return Result<NSURL, Error>.Success(imageURL)
                case .Failure(let error):
                    return Result<NSURL, Error>.Failure(error)
                }
            })
    }
    
    static func sendRequest(resultNSURL: Result<NSURL, Error>) -> Observable<Result<Data, Error>> {
        switch resultNSURL {
            //1
        case .Success(let imageURL):
            let baseURLString = imageURL.absoluteString
            let parameters: [String: String] = [:]
            var imageData: Data?
            return request(baseURLString!, parameters: parameters)
                .map({ result in
                    switch result {
                        //2
                    case .Success(let data):
                        if data.count < 6000 {
                            imageData = UIImage(named: "banff")!.pngData()
                        } else {
                            imageData = data
                        }
                        return Result<Data, Error>.Success(imageData!)
                        //3
                    case .Failure(let error):
                        return Result<Data, Error>.Failure(error)
                    }
                })
          case .Failure(let error):
            return Observable.just(Result<Data, Error>.Failure(error))
        }
    }
    
    static func getImage(resultNSURL: Result<NSURL, Error>, cache: ImageDataCachingProtocol.Type) -> Observable<Result<UIImage, Error>> {
        switch resultNSURL {
        case .Success(let imageURL):
            //1
            if let imageDataFromCache = cache.imageDataFromURLFromChache(url: imageURL) {
                let imageFromCache = UIImage(data: imageDataFromCache as Data)
                return Observable.just(Result<UIImage, Error>.Success(imageFromCache!))
            } else {
                //2
                return self.sendRequest(resultNSURL:resultNSURL)
                    .map() {(imageDataResult) in
                        switch imageDataResult {
                        case .Success(let imageData):
                            cache.saveImageDataToCache(data: imageData as NSData, url: imageURL)
                            let imageFromRequest = UIImage(data: imageData as Data)
                            return Result<UIImage, Error>.Success(imageFromRequest!)
                        case .Failure(let error):
                            return Result<UIImage, Error>.Failure(error)
                        }
                }
            }
            //3
        case .Failure(let error):
            return Observable.just(Result<UIImage, Error>.Failure(error))
        }
    }
    
    //MARK: - URL request
    static private func request(_ baseURL: String = "", parameters: [String: String] = [:]) -> Observable<Result<Data, Error>> {
        //1
        let defaultSession = URLSession(configuration: .default)
        var dataTask: URLSessionDataTask?
        //2
        return Observable.create { observer in
            var components = URLComponents(string: baseURL)!
            components.queryItems = parameters.map(URLQueryItem.init)
            let url = components.url!
            var result: Result<Data, Error>?
            dataTask = defaultSession.dataTask(with: url) { data, response, error in
                if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    result = Result<Data, Error>.Success(data)
                } else {
                    if let error = error {
                        result = Result<Data, Error>.Failure(error)
                    }
                }
                observer.onNext(result!)
                observer.onCompleted()
            }
            dataTask?.resume()
            //3
            return Disposables.create {
                dataTask?.cancel()
            }
        }
    }
}

