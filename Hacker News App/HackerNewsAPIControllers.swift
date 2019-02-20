//
//  APIControllers.swift
//  Hacker News App
//
//  Created by Alaeldin Tirba on 2/15/19.
//  Copyright © 2019 Alaeldin Tirba. All rights reserved.
//

import Foundation
import CoreData

enum Result<Value> {
    case success(Value)
    case failure(Error)
}


enum TypeOfStories: String {
    case newStories = "newstories"
    case topStories = "topstories"
    case bestStories = "beststories"
    case askStories = "askstories"
    case show = "showstories"
    case job = "jobstories"
}

class HackerNewsAPI {
    static var baseURL = URL(string: "https://hacker-news.firebaseio.com/v0/")
    static var dispatchGroup = DispatchGroup()
    
    class func getItemBy(idNumber: Int32, completion: @escaping ((Result<Item>) -> Void)) {
        let path = "item/\(idNumber).json"
        let url = URL(string: path, relativeTo: HackerNewsAPI.baseURL)!
        let  getSuccess: ((Data) -> Void) = { data in
            do {
                let object = try HackerNewsAPI.parseJson(data: data)
                completion(.success(object))
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(HackerNewsAPIError.invalidJSONResponse))
                }
            }
        }
        let getFailure: ((Error) -> Void) = { error in
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
        WebServiceManager.shared.get(url, headerFields: [:], success: getSuccess, failure: getFailure)
    }
    
    class func get(typeOfQuery:TypeOfStories, completion: @escaping ((Result<[Int32]>) -> Void)) {
        let path = "\(typeOfQuery.rawValue).json"
        let url = URL(string: path, relativeTo: HackerNewsAPI.baseURL)!
        let  getSuccess: ((Data) -> Void) = { data in
            do {
                let arrayOfStories = try JSONSerialization.jsonObject(with: data, options: []) as? [Int32]
                if let array = arrayOfStories {
                    completion(.success(array))
                }
                return
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(HackerNewsAPIError.invalidJSONResponse))
                }
            }
        }
        let getFailure: ((Error) -> Void) = { error in
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
        WebServiceManager.shared.get(url, headerFields: [:], success: getSuccess, failure: getFailure)
    }
    
    class func download(stories: [Int32], completion: @escaping (([Item]) -> Void)) {
        var storiesToReturn: [Item] = []
        let persistedStories = CoreDataService.fetchAllObjectsWith(itemIds: stories, item: Item.self) ?? []
        let retrievedFromCore = persistedStories.map({ $0.id})
        let taskGroup = DispatchGroup()
        for storyID in stories {
            taskGroup.enter()
            if retrievedFromCore.contains(storyID) {
                taskGroup.leave()
                continue
            }
            HackerNewsAPI.getItemBy(idNumber: storyID) { result in
                switch result {
                case .success(let story):
                    storiesToReturn.append(story)
                    taskGroup.leave()
                case .failure(_):
                    taskGroup.leave()
                    
                }
            }
            
        }
        
        taskGroup.notify(queue: DispatchQueue.main, work: DispatchWorkItem(block: {
            storiesToReturn.append(contentsOf: persistedStories)
            completion(storiesToReturn)
            DispatchQueue.main.async {
                CoreDataService.saveContext()
            }
        }))
        
    }
    
    static func getListOfStoriesAndDownload(type: TypeOfStories, completion: @escaping (([Item], [Int32]) -> Void)) {
        var downloadList: [Item]?
        HackerNewsAPI.get(typeOfQuery: type) { result in
            switch result {
            case .success(var stories):
                let maxIndx = min(stories.count-1, 20)
                let str = stories[0...maxIndx]
                self.download(stories: Array(str)) { lst in
                    downloadList = lst 
                    completion(downloadList ?? [], stories)
                }
            case .failure( _):
                completion(downloadList ?? [], [])
            }
        }
    }
    
    class func printJSON(data: Data) {
        guard let object = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else { return }
        if let object = object as? [String: Any] {
            guard let newData = try? JSONSerialization.data(withJSONObject: object, options: .prettyPrinted) else {
                return
                
            }
            guard String(data: newData, encoding: .utf8) != nil else { return }
        }
    }
    
    class func parseJson(data: Data) throws -> Item {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext else {
            fatalError("Failed to retrieve context")
        }
        
        let decoder = JSONDecoder()
        decoder.userInfo[codingUserInfoKeyManagedObjectContext] = CoreDataService.context
        printJSON(data: data)
        let object = try decoder.decode(Item.self, from: data)
        return object
        
    }
}
