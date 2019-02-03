//
//  Client.swift
//  OnTheMap
//
//  Created by Ahmed Sengab on 1/13/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

class Client {
    
    
    
    static func getPhotosUrl(lat:Double,lon:Double, completion: @escaping ([String] ,String?)->Void)
    {
        var urlArr : [String] = []
        var customHeaders : Dictionary = [String : String]()
        customHeaders[HeaderKeys.Accept] = HeaderValues.Accept
        customHeaders[HeaderKeys.ContentType] = HeaderValues.ContentType
        var  url =  "\(APIAdress.Flicker)?\(QueryString.APIKey)=\(QueryString.APIKeyValue)"
        url += "&\(QueryString.Method)=\(QueryString.MethodValue)&\(QueryString.Format)=\(QueryString.FormatValue)"
        url += "&\(QueryString.Lat)=\(lat)&\(QueryString.Lon)=\(lon)&\(QueryString.Tags)=\(QueryString.TagsValue)"
        url += "&\(QueryString.PerPgae)=\(QueryString.PerPgaeValue)&\(QueryString.Accuracy)=\(QueryString.AccuracyValue)"
        url += "&\(QueryString.Page)=\(QueryString.PageValue)&\(QueryString.JsonCallBack)=\(QueryString.JsonCallBackValue)"
        
        APIService.SendRequest(requestUrl: url, requestMethod: nil, customHeaders: customHeaders,headers: nil,
                               body: nil) { data,error,statusCode in
                                var errorMsg : String?
                                if  error == nil
                                {
                                    if statusCode > 299  {
                                        errorMsg =  "Something went wrong"
                                        
                                    }
                                    else {
                                        if let data = data
                                        {
                                            if let json = try? JSONSerialization.jsonObject(with: data, options: []),
                                                let dict = json as? [String:Any],
                                                let photos = dict["photos"] as? [String:Any],
                                                let photoArr = photos["photo"] as? [[String:Any]]
                                            {
                                                
                                                for photoInfo in photoArr {
                                                    
                                                    let imageURL = "https://farm\(photoInfo["farm"]!).staticflickr.com/\(photoInfo["server"]!)/\(photoInfo["id"]!)_\(photoInfo["secret"]!).jpg"
                                                    urlArr.append(  imageURL)
                                                    
                                                }
                                            } else { //Err in parsing data
                                                errorMsg  = "Couldn't parse response"
                                                
                                            }
                                        }
                                    }
                                }
                                else    {
                                    errorMsg =  error
                                    
                                }
                                DispatchQueue.main.async {
                                    completion(urlArr, errorMsg)
                                }
        }
        
        
    }
    
    
    static func downloadPhoto(url:String, completion: @escaping (Data? ,String?)->Void)
    {
        
        APIService.SendRequest(requestUrl: url, requestMethod: nil, customHeaders: nil,headers: nil,
                               body: nil) { data,error,statusCode in
                                var errorMsg : String?
                                if  error == nil
                                {
                                    if statusCode > 299  {
                                        errorMsg =  "Something went wrong"  
                                    }
                                }
                                else    {
                                    errorMsg =  error
                                    
                                }
                                DispatchQueue.main.async {
                                    completion(data, errorMsg)
                                }
        }
        
        
    }
    
    
    
    
    
}

