//
//  StoryModel.swift
//  Hacker News App
//
//  Created by Alaeldin Tirba on 2/14/19.
//  Copyright © 2019 Alaeldin Tirba. All rights reserved.
//

import Foundation
import CoreData

public extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}


class Item: NSManagedObject, Decodable {
    
    enum Keys: String, CodingKey {
        case author = "by"
        case dead = "dead"
        case descendants = "descendants"
        case itemDeleted = "deleted"
        case id = "id"
        case kids = "kids"
        case parent = "parent"
        case parts = "parts"
        case poll = "poll"
        case score = "score"
        case text = "text"
        case time = "time"
        case title = "title"
        case type = "type"
        case url = "url"
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Item", in: managedObjectContext) else {
                print("problem decoding item")
                fatalError("Failed to decode Item")
    
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        do {
            let values = try decoder.container(keyedBy: Keys.self)
            self.id = try values.decode(Int32.self, forKey: .id)
            self.author = try values.decodeIfPresent(String.self, forKey: .author)
            self.title = try values.decodeIfPresent(String.self, forKey: .title)
            let unixTime = try values.decodeIfPresent(Double.self, forKey: .time)
            self.time = Date(timeIntervalSince1970: unixTime!)
            self.type = try values.decodeIfPresent(String.self, forKey: .type)
            self.kids = (try values.decodeIfPresent([Int32].self, forKey: .kids) ?? []) as NSObject
            self.descendants = try values.decodeIfPresent(Int32.self, forKey: .descendants) ?? 0
            self.score = try  values.decodeIfPresent(Int32.self, forKey: .score) ?? 0
            let urlString = try values.decodeIfPresent(String.self, forKey: .url)
            self.url = URL(string: urlString ?? "")
            self.itemDeleted = (try values.decodeIfPresent(Bool.self, forKey: .itemDeleted)) ?? false
            self.poll = try values.decodeIfPresent(Int32.self, forKey: .poll) ?? 0
            self.parent = try values.decodeIfPresent(Int32.self, forKey: .parent) ?? 0
            self.dead = try values.decodeIfPresent(Bool.self, forKey: .dead) ?? false
            self.text = try values.decodeIfPresent(String.self, forKey: .text)
            self.parts = (try values.decodeIfPresent([Int32].self, forKey: .parts) ?? []) as NSObject
            self.dateSince = calculateDaysSince(startDate: time ?? Date())
        } catch {
            print("error parsing")
        }
    }
    
    func calculateDaysSince(startDate: Date)  -> String {
        let currentDate = Date()
        let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .month, .year])
        let differenceOfDate = Calendar.current.dateComponents(components, from: startDate, to: currentDate)
        if differenceOfDate.year ?? 0 > 0 {
            return "\(differenceOfDate.year) Years"
        } else if differenceOfDate.month ?? 0 > 0 {
            return "\(differenceOfDate.month) Months"
        } else if differenceOfDate.day ?? 0 > 0 {
            return "\(differenceOfDate.day ?? 0) Days"
        } else if differenceOfDate.hour ?? 0 > 0 {
            return "\(differenceOfDate.hour ?? 0) Hours"
        } else if differenceOfDate.minute ?? 0 > 0 {
            return "\(differenceOfDate.minute ?? 0) Mins"
        } else {
            return "\(differenceOfDate.second ?? 0) Secs"
        }
        
    }
}


