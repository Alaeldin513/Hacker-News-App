//
//  JobTableViewCell.swift
//  Hacker News App
//
//  Created by Alaeldin Tirba on 2/20/19.
//  Copyright © 2019 Alaeldin Tirba. All rights reserved.
//

import UIKit

class JobTableViewCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var daysSinceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.layer.cornerRadius = 20
        self.backgroundColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(with job: Item?) {
        if let job = job {
            titleLabel.text = job.title
            daysSinceLabel.text = job.dateSince
        }
    }
    
}
