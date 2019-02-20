//
//  APIControllers.swift
//  Hacker News App
//
//  Created by Alaeldin Tirba on 2/15/19.
//  Copyright © 2019 Alaeldin Tirba. All rights reserved.
//

import Foundation

enum Result<Value> {
    case success(Value)
    case failure(Error)
}
class HackNewsAPI {
    var baseURL = "https://hacker-news.firebaseio.com/v0/item/"
    
    func getStory(idNumber: Int? , completion: @escaping (Result<Story>) -> Void) {
        let path = "\(idNumber)"
        let url = URL(string: path, relativeTo: baseURL)!
        WebServiceManager.shared.get(url, success: { (data: Data) -> Void in
            do {
                let json_load = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: AnyObject]
                let load = ManagedLoad.insertOrUpdate(json_load)
                DispatchQueue.main.async {
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    success(load)
                }
            } catch {
                DispatchQueue.main.async {
                    failure(TQLMobileAPIError.invalidJSONResponse)
                }
            }
        }, failure: { (error) -> Void in
            DispatchQueue.main.async {
                failure(error)
            }
        })
        
    }
    
    
    func getComment() {
        
    }
    
    func getAsk() {
        
    }
    
    func getPoll() {

    }
}
