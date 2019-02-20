//
//  AskTableViewController.swift
//  Hacker News App
//
//  Created by Alaeldin Tirba on 2/19/19.
//  Copyright © 2019 Alaeldin Tirba. All rights reserved.
//

import UIKit
import Foundation
import MBProgressHUD

class AskViewController: UIViewController, ReusableTableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var asks: [Item]!
    var listOfStoriesID: [Int32]?
    var reuseableTable: ReusableTableViewController!
    var reuseableTableDelegate: ReusableTableViewDelegate?
    var selectedItem: Item!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        var hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = .annularDeterminate
        hud.label.text = "Fetching Questions"
        HackerNewsAPI.getListOfStoriesAndDownload(type: .askStories) { downloadedStories,lstOfStories in
            DispatchQueue.main.async {
                self.asks = downloadedStories
                self.listOfStoriesID = lstOfStories
                self.reuseableTable = ReusableTableViewController(self.tableView, downloadedStories, availableForDownload: lstOfStories, viewController: self, nibFileName: "StoryTableViewCell")
                self.reuseableTable.delegate = self
                self.tableView.reloadData()
                hud.hide(animated: true)
            }
            
        }
        hud.hide(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToDetails" {
            //swiftlint:disable force_cast
            let detailsVC = segue.destination as! TextViewController
            detailsVC.ask = selectedItem
            //swiftlint:enable force_cast
        }
    }
    
    func didSelect(item: Item) {
        selectedItem = item
    }

    
}


extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}


