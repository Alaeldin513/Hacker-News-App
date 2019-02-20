//
//  CommentModel.swift
//  Hacker News App
//
//  Created by Alaeldin Tirba on 2/14/19.
//  Copyright © 2019 Alaeldin Tirba. All rights reserved.
//

import Foundation
import CoreData

class Comment: NSManagedObject, Decodable {


    enum Keys: String, CodingKey {
        case id = "id"
        case author = "by"
        case text = "text"
        case time =  "time"
        case type =  "type"
        case parent = "parent"
        case kids = "kids"
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Comment", in: managedObjectContext) else {
                fatalError("Failed to decode User")
        }
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let values = try decoder.container(keyedBy: Keys.self)
        self.id = Int32(try values.decode(Int.self, forKey: .id))
        self.author = try? values.decode(String.self, forKey: .author)
        self.text = try? values.decode(String.self, forKey: .text)
        let unixTime = try? values.decode(Double.self, forKey: .time)
        self.time = Date(timeIntervalSince1970: unixTime!)
        self.type = try values.decode(String.self, forKey: .type)
        self.parent = Int32(try values.decode(Int.self, forKey: .parent))
        self.kids = try values.decode([Int].self, forKey: .kids) as NSObject
        self.dateSince = calculateDaysSince(startDate: time ?? Date())
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


