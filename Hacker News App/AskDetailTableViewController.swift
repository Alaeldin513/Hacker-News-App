//
//  AskDetailTableViewController.swift
//  Hacker News App
//
//  Created by Alaeldin Tirba on 2/19/19.
//  Copyright © 2019 Alaeldin Tirba. All rights reserved.
//

import Foundation
import UIKit

class TextViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var askTitle: UILabel!
    @IBOutlet weak var detailsNavigationItem: UINavigationItem!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var comments: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var dateSincePostedLabel: UILabel!
    
    
    var ask: Item!
    var listOfComments: [Item]?
    var kidsAlreadyDownloaded: [Int32]?
    
    
    override func viewDidLoad() {
        registerNibFiles()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorColor = .gray
        self.tableView.separatorStyle = .singleLine
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if ask != nil {
            HackerNewsAPI.download(stories: ask?.kids as? [Int32] ?? []) { comments in
                DispatchQueue.main.async {
                    self.listOfComments = comments
                    self.tableView.reloadData()
                }
            }
        }
        let backButton: UIBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(dismissView))
        self.detailsNavigationItem.leftBarButtonItem = backButton;
    }
    
    func get(lstOfComments: [Int32]) {
        
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func registerNibFiles() {
        let titleCell = UINib(nibName: "AskTitleTableViewCell", bundle: nil)
        self.tableView.register(titleCell, forCellReuseIdentifier: "titleCell")
        let commentCell = UINib(nibName: "CommentTableViewCell", bundle: nil)
        self.tableView.register(commentCell, forCellReuseIdentifier: "commentCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ask != nil ? 2:0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return listOfComments?.count ?? 0
        }
    }
    
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var kids = listOfComments?[indexPath.row].kids as? [Int32]
        kids = Array(Set(kids ?? []).subtracting(Set(kidsAlreadyDownloaded ?? [])))
        self.kidsAlreadyDownloaded = (kidsAlreadyDownloaded ?? []) + (kids ?? [])
        HackerNewsAPI.download(stories: kids ?? []) { comments in
            DispatchQueue.main.async {
                var finalComments = Array(self.listOfComments?[0...(indexPath.row)] ?? [])
                finalComments.append(contentsOf: comments)
                let maxIndx = self.listOfComments?.count ?? 0
                var minIndx = min((indexPath.row + 1), maxIndx)
                finalComments.append(contentsOf: Array(self.listOfComments?[minIndx..<maxIndx] ?? []))
                self.listOfComments = finalComments
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath) as! AskTitleTableViewCell
            cell.configure(with: self.ask)
            askTitle.text = ask.title
            dateSincePostedLabel.text = ask.dateSince
            scoreLabel.text = "\(ask.score)"
            comments.text = "\(ask.descendants)"
            authorLabel.text = ask.author
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentTableViewCell
            cell.configure(with: (listOfComments?[indexPath.row]))
            return cell
        }
        // swiftlint:enable force_cast
    }
    
   
    
}
