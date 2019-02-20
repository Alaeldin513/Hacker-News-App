//
//  CommentTableViewCell.swift
//  Hacker News App
//
//  Created by Alaeldin Tirba on 2/19/19.
//  Copyright © 2019 Alaeldin Tirba. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var daysSinceLabel: UILabel!
    @IBOutlet weak var numOfKidsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.separatorInset = UIEdgeInsets.zero
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with comment: Item?) {
        if let comment = comment {
            commentLabel.text = comment.text?.htmlToString
            authorLabel.text = comment.author
            daysSinceLabel.text = comment.dateSince
            let kids = comment.kids as? [Int32]
            numOfKidsLabel.text = "+\(kids?.count ?? 0)"
        }
    }
    
}
