//
//  CoreDataService.swift
//  Hacker News App
//
//  Created by Alaeldin Tirba on 2/15/19.
//  Copyright © 2019 Alaeldin Tirba. All rights reserved.
//

import Foundation
import CoreData


enum ContextErrors: Error {
    case errorLoading(String)
}


class CoreDataService {
    
    private init() {}
    
    static var context: NSManagedObjectContext? {
        return persistentContainer?.viewContext
    }
    
    // MARK: - Core Data stack
    static var persistentContainer: NSPersistentContainer? = {
        
        let container = NSPersistentContainer(name: "Hacker_News_App")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                
                print("attempt to load persistant stores has failed")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
   static func saveContext () throws {
        let context = persistentContainer?.viewContext
        if context?.hasChanges ?? false {
            do {
                try context?.save()
            } catch {
               throw ContextErrors.errorLoading("attempted to save but failed")
            }
        }
    }
    
    static func deleteAllData(_ entity: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try CoreDataService.context?.fetch(fetchRequest)
            for object in results ?? [] {
                guard let objectData = object as? NSManagedObject else {continue}
                CoreDataService.context?.delete(objectData)
            }
        } catch let error {
            print("Detele all data in \(entity) error :", error)
        }
    }
    
    // swiftlint:disable force_cast
    static func fetchAllObjectsWith<T: NSManagedObject>(itemIds: [Int32], item: T.Type) -> [T]? {
        do {
            let fetchRequest: NSFetchRequest<T> = T.fetchRequest() as! NSFetchRequest<T>
            fetchRequest.predicate = NSPredicate(format: "id IN %@", itemIds)
            let fetchedResults = try context?.fetch(fetchRequest)
            return fetchedResults
        } catch {
            return []
        }
    }
    // swiftlint:enable force_cast
    
    static func doesExist(id: Int, entityname: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityname)
        fetchRequest.predicate = NSPredicate(format: "id = %d", argumentArray: [id])
        
        let res = (try? CoreDataService.context?.fetch(fetchRequest)) ?? []
        return (res?.count) ?? 0 > 0 ? true : false
    }
}
