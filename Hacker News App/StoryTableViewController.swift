//
//  ViewController.swift
//  Hacker News App
//
//  Created by Alaeldin Tirba on 2/14/19.
//  Copyright © 2019 Alaeldin Tirba. All rights reserved.
//

import UIKit
import SafariServices
import CoreData
import MBProgressHUD


class StoryTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var stories: [Item]!
    var listOfStoriesID: [Int32]?
    var reuseTable: ReusableTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = .annularDeterminate
        hud.label.text = "Fetching News"
        HackerNewsAPI.getListOfStoriesAndDownload(type: .topStories) { downloadedStories, lstOfStories in
            DispatchQueue.main.async {
                self.stories = downloadedStories
                self.listOfStoriesID = lstOfStories
                self.reuseTable = ReusableTableViewController(self.tableView, downloadedStories, availableForDownload: lstOfStories, viewController: self, nibFileName: "StoryTableViewCell")
                self.tableView.reloadData()
                hud.hide(animated: true)
            }
        }
        hud.hide(animated: true)
    }
    
    
}
