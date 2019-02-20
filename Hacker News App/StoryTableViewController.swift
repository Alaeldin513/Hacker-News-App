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


class MainPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var stories: [Story]!
    var listOfStoriesID: [Int32]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibFiles()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        self.tableView.dataSource = self
        self.tableView.delegate = self
        HackerNewsAPI.getListOfStoriesAndDownload() { downloadedStories,lstOfStories in
            DispatchQueue.main.async {
                self.stories = downloadedStories
                self.listOfStoriesID = lstOfStories
                self.tableView.reloadData()
            }
        }
    }
    
    private func updateView() {
       // tableView.isHidden = !storiesToDownload.isEmpty
        //messageLabel.isHidden = hasQuotes
    }
    
    func registerNibFiles() {
        let storyCell = UINib(nibName: "StoryTableViewCell", bundle: nil)
        tableView.register(storyCell, forCellReuseIdentifier: "StoryCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (stories?.count) ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoryCell", for: indexPath) as! StoryTableViewCell
        let story = stories?[indexPath.section]
        cell.configure(with: story!)
        return cell
        // swiftlint:enable force_cast
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(stories[indexPath.section])
        print(stories[indexPath.section].url)
        if let url = stories[indexPath.section].url {
            let safariVC = SFSafariViewController(url: url)
            self.present(safariVC, animated: true, completion: nil)
           
        }
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .white
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print(indexPath.section)
        guard indexPath.section > stories.count - 5, indexPath.section < listOfStoriesID?.count ?? 0 - 1 else { return }
        let upperBound = min(listOfStoriesID?.count ?? 0, stories.count + 20)
        var storiesToDownload = listOfStoriesID?[stories.count..<upperBound]
        HackerNewsAPI.download(stories: Array(storiesToDownload ?? [])) { lst in
            DispatchQueue.main.async {
                self.stories.append(contentsOf: lst)
                tableView.reloadData()
            }
        }
     
    }
    
}
