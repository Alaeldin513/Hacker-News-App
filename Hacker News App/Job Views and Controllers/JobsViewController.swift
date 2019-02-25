//
//  JobsViewController.swift
//  Hacker News App
//
//  Created by Alaeldin Tirba on 2/20/19.
//  Copyright © 2019 Alaeldin Tirba. All rights reserved.
//

import UIKit
import MBProgressHUD

class JobsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var stories: [Item]!
    var listOfStoriesID: [Int32]?
    var reuseTable: ReusableTableViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = .annularDeterminate
        hud.label.text = "Fetching Jobs"
        HackerNewsAPI.getListOfStoriesAndDownload(type: .job) { downloadedStories, lstOfStories in
            DispatchQueue.main.async {
                self.stories = downloadedStories
                self.listOfStoriesID = lstOfStories
                self.reuseTable = ReusableTableViewController(self.tableView, downloadedStories, availableForDownload: lstOfStories, viewController: self, nibFileName: "JobTableViewCell")
                self.tableView.reloadData()
                hud.hide(animated: true)
            }
        }
    }

}
