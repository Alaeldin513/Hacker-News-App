//
//  AskTableViewCell.swift
//  Hacker News App
//
//  Created by Alaeldin Tirba on 2/19/19.
//  Copyright © 2019 Alaeldin Tirba. All rights reserved.
//

import UIKit

class AskTitleTableViewCell: UITableViewCell {

    @IBOutlet weak var askDetailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with ask: Item){
        if ask  != nil {
            self.askDetailLabel.text = ask.text?.htmlToString
        }
    }
}
