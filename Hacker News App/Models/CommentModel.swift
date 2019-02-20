//
//  CommentModel.swift
//  Hacker Rank App
//
//  Created by Alaeldin Tirba on 2/14/19.
//  Copyright © 2019 Alaeldin Tirba. All rights reserved.
//

import Foundation

struct Comment {
    var id: Int
    var author: String?
    var text: String?
    var time: Date?
    var type: String = "Comment"
    var parent: Int?
    var kids: Int?
}
