//
//  APIKeys.swift
//  OnTheMap
//
//  Created by Ahmed Sengab on 1/13/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

struct HeaderKeys {
    static let Accept = "Accept"
    static let ContentType = "Content-Type"
    
}

struct HeaderValues {
    static let Accept = "application/json"
    static let ContentType = "application/json"
}

struct APIAdress {
    static let Flicker = "https://api.flickr.com/services/rest"
}

struct QueryString {
    static let APIKey  = "api_key"
    static let APIKeyValue  = "08f0d4955f3b89facecd4feede1f1fe6"
    static let Method  = "method"
    static let MethodValue  = "flickr.photos.search"
    static let Format  = "format"
    static let FormatValue  = "json"
    static let Lat  = "lat"
    static let LatValue  = 0
    static let Lon  = "lon"
    static let LonValue  = 0
    static let Tags  = "tags"
    static let TagsValue  = ""
    static let PerPgae  = "per_page"
    static let PerPgaeValue  = 10
    static let Accuracy  = "accuracy"
    static let AccuracyValue  = 11
    static let Page  = "page"
    static let PageValue  = Int.random(in: 1..<20)
    static let JsonCallBack = "nojsoncallback"
    static let JsonCallBackValue = 1
    
}

enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
}
