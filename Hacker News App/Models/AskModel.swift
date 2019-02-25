//
//  AskModel.swift
//  Hacker News App
//
//  Created by Alaeldin Tirba on 2/14/19.
//  Copyright © 2019 Alaeldin Tirba. All rights reserved.
//

import Foundation
import CoreData

class Ask: NSManagedObject, Decodable {
//    var id: Int
//    var author: String?
//    var title: String?
//    var text: String?
//    var time: Date?
//    var type: String?
//    var descendents: Int?
//    var kids: [Int]?
//    var score: Int?

    enum Keys: String, CodingKey {
        case id = "id"
        case author = "by"
        case title = "title"
        case text = "text"
        case time =  "time"
        case type =  "type"
        case descendants = "descendants"
        case kids = "kids"
        case score = "score"
    }
    required convenience init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Ask", in: managedObjectContext) else {
                fatalError("Failed to decode User")
        }
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let values = try decoder.container(keyedBy: Keys.self)
        self.id = try values.decode(Int32.self, forKey: .id)
        self.author = try? values.decode(String.self, forKey: .author)
        self.title = try? values.decode(String.self, forKey: .title)
        self.text = try? values.decode(String.self, forKey: .text)
        let unixTime = try? values.decode(Double.self, forKey: .time)
        self.time = Date(timeIntervalSince1970: unixTime!)
        self.type = try values.decode(String.self, forKey: .type)
        self.kids = try values.decode([Int].self, forKey: .kids) as NSObject
        self.descendents = try values.decode(Int32.self, forKey: .descendants)
        self.score = try values.decode(Int32.self, forKey: .score)
        self.dateSince = calculateDaysSince(startDate: time ?? Date())
    }
    
    func calculateDaysSince(startDate: Date) -> String {
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
