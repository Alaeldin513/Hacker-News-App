//
//  ReuseableTableViewController.swift
//  Hacker News App
//
//  Created by Alaeldin Tirba on 2/19/19.
//  Copyright © 2019 Alaeldin Tirba. All rights reserved.
//

import UIKit
import SafariServices
import MBProgressHUD

protocol ReusableTableViewDelegate {
    func didSelect(item: Item)
}

class ReusableTableViewController: NSObject, UITableViewDelegate, UITableViewDataSource {
    var data: [Item]?
    var listOfStoriesID: [Int32]?
    var tableView: UITableView!
    var nibFileName: String!
    var mainViewController: UIViewController!
    var delegate: ReusableTableViewDelegate?
    

    init(_ table: UITableView, _ data: [Item], availableForDownload: [Int32],viewController: UIViewController, nibFileName: String)
    {
        self.data = data
        self.tableView = table
        self.mainViewController = viewController
        self.listOfStoriesID = availableForDownload
        self.nibFileName = nibFileName
        super.init()
        tableView.delegate = self
        tableView.dataSource = self
        
        // Register all of your cells
        tableView.register(UINib(nibName: nibFileName, bundle: nil), forCellReuseIdentifier: "GenericCell")
    }
    private func updateView() {
        // tableView.isHidden = !storiesToDownload.isEmpty
        //messageLabel.isHidden = hasQuotes
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return (data?.count) ?? 0
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 2
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast
        switch nibFileName {
        case "StoryTableViewCell":
            let cell = tableView.dequeueReusableCell(withIdentifier: "GenericCell", for: indexPath) as! StoryTableViewCell
            let story = data?[indexPath.section]
            cell.configure(with: story!)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GenericCell", for: indexPath) as! JobTableViewCell
            let story = data?[indexPath.section]
            cell.configure(with: story!)
            return cell
        }
        
        // swiftlint:enable force_cast
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = data?[indexPath.section].url {
            let safariVC = SFSafariViewController(url: url)
            mainViewController.present(safariVC, animated: true, completion: nil)
        } else if let selectedItem = data?[indexPath.section], let text = data?[indexPath.section].text {
            delegate?.didSelect(item: selectedItem)
            mainViewController.performSegue(withIdentifier: "segueToDetails", sender: self)
        }
    }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .white
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print(indexPath.section)
        guard indexPath.section > (data?.count ?? 0) - 5, indexPath.section < (listOfStoriesID?.count ?? 0) - 1 else { return }
        var hud = MBProgressHUD.showAdded(to: mainViewController.view, animated: true)
        hud.mode = .annularDeterminate
        let upperBound = min(listOfStoriesID?.count ?? 0, (data?.count ?? 0) + 20)
        var storiesToDownload = listOfStoriesID?[(data?.count ?? 0)..<upperBound]
        HackerNewsAPI.download(stories: Array(storiesToDownload ?? [])) { lst in
            DispatchQueue.main.async {
                if let data = self.data {
                    self.data = data + lst
                }
                print(self.data?.count)
                tableView.reloadData()
                hud.hide(animated: true)
            }
        }
        
    }

}
