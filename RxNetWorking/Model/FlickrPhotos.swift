//
//  FlickrPhotos.swift
//  RxNetWorking
//
//  Created by Jun Dang on 2018-09-23.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import Foundation

struct FlickrModel: Codable {
    private enum CodingKeys : String, CodingKey {
        case flickrModel = "photos" }
    var flickrModel: FlickrPhotos?
}

struct FlickrPhotos: Codable {
    private enum CodingKeys : String, CodingKey {
        case flickrPhotos = "photo" }
    var flickrPhotos: [FlickrPhoto] = []
}

struct FlickrPhoto: Codable {
    var farm: Int = 0
    var server: String = ""
    var id: String = ""
    var secret: String = ""
    
    private enum CodingKeys: String, CodingKey {
        case farm = "farm", server = "server", id = "id", secret = "secret"
    }
    init(farm: Int, id: String, server: String, secrect: String) {
        self.farm = farm
        self.id = id
        self.server = server
        self.secret = secrect
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        farm = try container.decode(Int.self, forKey: .farm)
        server = try container.decode(String.self, forKey: .server)
        id = try container.decode(String.self, forKey: .id)
        secret = try container.decode(String.self, forKey: .secret)
    }
    func createImageURL() -> NSURL {
        return NSURL(string: "http://farm\(String(describing: farm)).staticflickr.com/\(String(describing: server))/\(String(describing: id))_\(String(describing: secret))_b.jpg")!
    }
}
