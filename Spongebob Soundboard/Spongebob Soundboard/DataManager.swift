//
//  DataManager.swift
//  Spongebob Soundboard
//
//  Created by Harsha Goli on 10/19/17.
//  Copyright © 2017 Harsha Goli. All rights reserved.
//

import Foundation

class DataManager {

    
    /*
     PARAMS
     
     URL - url of server + method wrapped in URL
     httpMethod - For example: "GET", "POST", "PUT", "DELETE" etc
     postData - body in string form. Be sure to include and escape quotations for string keys
     auth - String key, string value dictionary. Should have "username" key and "password" key, will fail if not present
     headers - header for request
     completionHandler - block that is to be executed on the response. Block has three optional parameters of type Data, URLResponse, Error.
     Returns void
     */
    func executeRequest(URL: URL, httpMethod: String, postData: String? = nil, auth: [String:String]? = nil, headers: [String: String] = ["content-type": "application/json", "cache-control": "no-cache"], completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void){
        
        var hdrs = headers
        let request = NSMutableURLRequest(url: URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        if (postData != nil){
            request.httpBody = NSData(data: postData!.data(using: String.Encoding.utf8)!) as Data
        }
        if (auth != nil){
            let loginString = NSString(format: "%@:%@", auth!["username"]!, auth!["password"]!)
            let loginData: NSData = loginString.data(using: String.Encoding.utf8.rawValue)! as NSData
            let base64LoginString = loginData.base64EncodedString(options: [])
            hdrs.updateValue("Basic \(base64LoginString)", forKey: "authorization")
        }
        request.httpMethod = httpMethod
        request.allHTTPHeaderFields = hdrs
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: completionHandler)
        
        //Execute the call
        dataTask.resume()
    }
    
}

