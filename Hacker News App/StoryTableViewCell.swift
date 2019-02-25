//
//  StoryTableViewCell.swift
//  Hacker News App
//
//  Created by Alaeldin Tirba on 2/17/19.
//  Copyright © 2019 Alaeldin Tirba. All rights reserved.
//

import UIKit

class StoryTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var numOfCommentsLabel: UILabel!
    @IBOutlet weak var numOfLikesLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var authorNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.layer.cornerRadius = 20
        self.backgroundColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with story: Item) {
        DispatchQueue.main.async {
            self.titleLabel.text = story.title
            self.numOfLikesLabel.text = "\(story.score)"
            self.numOfCommentsLabel.text = "\(story.descendants)"
            self.authorNameLabel.text = story.author
            if let dateSinceUpload = story.dateSince {
                self.dateLabel.text = dateSinceUpload
            }
        }
    }
}
