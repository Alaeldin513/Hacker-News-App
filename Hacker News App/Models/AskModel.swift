//
//  AskModel.swift
//  Hacker Rank App
//
//  Created by Alaeldin Tirba on 2/14/19.
//  Copyright © 2019 Alaeldin Tirba. All rights reserved.
//

import Foundation

struct Ask {
    var id: Int
    var author: String?
    var title: String?
    var text: String?
    var time: Date?
    var type: String = "Story"
    var descendents: Int?
    var kids: Int?
    var score: Int?
    var url: URL
}


