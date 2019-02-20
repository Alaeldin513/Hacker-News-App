//
//  WebServiceManager.swift
//  Hacker News App
//
//  Created by Alaeldin Tirba on 2/15/19.
//  Copyright © 2019 Alaeldin Tirba. All rights reserved.
//

import Foundation

class WebServiceManager {
    
    static var shared = WebServiceManager()
    
    var session: URLSession {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["content-type": "application/json"]
        config.timeoutIntervalForRequest = 15
        return URLSession(configuration: config)
    }
    
    // MARK: - HTTP Methods
    func get(_ url: URL, headerFields: [String: String], success: @escaping ((_ data: Data) -> Void), failure: @escaping ((_ error: Error) -> Void)) {
        var request = URLRequest(url: url)
        for (key, value) in headerFields {
            request.addValue(value, forHTTPHeaderField: key)
        }
        performDataTask(request, success: success, failure: failure)
    }
    
    
    fileprivate func performDataTask(_ request: URLRequest, success: @escaping ((_ data: Data) -> Void), failure: @escaping ((_ error: Error) -> Void)) {
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                failure(error!)
            } else {
                success(data!)
            }
        }
        task.resume()
    }
    
}
