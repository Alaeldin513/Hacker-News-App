//
//  JobModel.swift
//  Hacker Rank App
//
//  Created by Alaeldin Tirba on 2/14/19.
//  Copyright © 2019 Alaeldin Tirba. All rights reserved.
//

import Foundation

struct Poll: Codable {
    var id: Int
    var author: String?
    var title: String?
    var text: String?
    var descendants: [Int]
    var kids: [Int]
    var parts: [Int]?
    var score: Int?
    var time: Date
    var type: String?
    
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
}


extension Poll {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: Keys.self)
        id = try values.decode(Int.self, forKey: .id)
        author = try values.decode(String.self, forKey: .author)
        title = try values.decode(String.self, forKey: .title)
        text = try values.decode(String.self, forKey: .text)
        descendants = try values.decode(Array.self, forKey: .descendants)
        kids = try values.decode(Array.self, forKey: .kids)
        parts = try values.decode(Array.self, forKey: .parts)
        score = try values.decode(Int.self, forKey: .score)
        time = try values.decode(Date.self, forKey: .time)
        type = try values.decode(String.self, forKey: .id)
    }
}
