//
//  JobModel.swift
//  Hacker News App
//
//  Created by Alaeldin Tirba on 2/14/19.
//  Copyright © 2019 Alaeldin Tirba. All rights reserved.
//

import Foundation
import CoreData

class Poll: NSManagedObject, Decodable {
    
    enum Keys: String, CodingKey{
        case id = "id"
        case author = "by"
        case title = "title"
        case text = "text"
        case descendants = "descendants"
        case kids = "kids"
        case parts = "parts"
        case score = "score"
        case time =  "time"
        case type =  "type"
    }
    
    required convenience init(from decoder: Decoder) throws {
        
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Poll", in: managedObjectContext) else {
                fatalError("Failed to decode User")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let values = try decoder.container(keyedBy: Keys.self)
        id = Int32(try values.decode(Int.self, forKey: .id))
        author = try? values.decode(String.self, forKey: .author)
        title = try? values.decode(String.self, forKey: .title)
        text = try? values.decode(String.self, forKey: .text)
        descendants = Int32(try values.decode(Int.self, forKey: .descendants))
        kids = try? values.decode([Int].self, forKey: .kids) as NSObject
        parts = try? values.decode([Int].self, forKey: .parts) as NSObject
        score = Int32(try values.decode(Int.self, forKey: .score))
        let unixTime = try? values.decode(Double.self, forKey: .time)
        time = Date(timeIntervalSince1970: unixTime!)
        type = try? values.decode(String.self, forKey: .type)
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

