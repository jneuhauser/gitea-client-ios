//
//  PullRequestsTableViewController.swift
//  Gitea
//
//  Created by Johann Neuhauser on 13.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import UIKit

class PullRequestsTableViewController: UITableViewController {

    private var pullRequests: [PullRequest]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.navigationController?.navigationBar.topItem?.title = "Pull Requests"
        
        tableView.register(UINib(nibName: "IssueTableViewCell", bundle: nil), forCellReuseIdentifier: "IssueCellFromNib")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let loginViewController = presentingViewController as? LoginViewController {
            // TODO: Setup logout button
            //loginViewController.dismiss(animated: true)
            debugPrint("My presenting view controller is: \(loginViewController)")
        }
        
        // Load pull requests data only if not loaded before
        if pullRequests == nil {
            loadPullRequestsAsync()
        }
    }
    
    private func loadPullRequestsAsync() {
        // TODO: Load the pull requests of the selected repo
        Networking.shared.getPullRequests(fromOwner: "devel", andRepo: "test1-cpp") { result in
            switch result {
            case .success(let pullRequests):
                debugPrint(pullRequests)
                self.pullRequests = pullRequests
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                }
            case .failure(let error):
                debugPrint("getPullRequests() failed with \(error)")
            }
        }
    }

    @IBAction func refreshAction(_ sender: UIRefreshControl) {
        loadPullRequestsAsync()
    }
    
    // MARK: - Table view delegates
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowPullRequestDetail", sender: self)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pullRequests?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IssueCellFromNib", for: indexPath)
        
        guard let pullRequest = pullRequests?[indexPath.row] else {
            return cell
        }
        
        if let issueTVC = cell as? IssueTableViewCell {
            if let state = pullRequest.state, state == .closed,
                let merged = pullRequest.merged, merged
            {
                issueTVC.imageView?.image = UIImage(named: "git-merge")
            } else {
                issueTVC.imageView?.image = UIImage(named: "git-pull-request")
            }
            
            issueTVC.titleLabel?.text = pullRequest.title
            
            if let number = pullRequest.number,
                let state = pullRequest.state,
                let user = pullRequest.user?.login,
                let createdSince = pullRequest.createdAt?.getDifferenceToNow(withUnitCount: 1) {
                let state = state == .closed ? "closed" : "opened"
                debugPrint(createdSince)
                issueTVC.footerLabel?.text = "#\(number) \(state) \(createdSince) ago by \(user)"
            } else {
                issueTVC.footerLabel?.text = nil
            }
            
            if let comments = pullRequest.comments, comments > 0 {
                issueTVC.commentsLabel?.text = "💬 \(comments)"
            } else {
                issueTVC.commentsLabel?.text = nil
            }
        } else {
            cell.textLabel?.text = pullRequest.title
            
            if let state = pullRequest.state, state == .closed,
                let merged = pullRequest.merged, merged
            {
                cell.imageView?.image = UIImage(named: "git-merge")
            } else {
                cell.imageView?.image = UIImage(named: "git-pull-request")
            }
        }
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        debugPrint(segue)
        
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
        case "ShowPullRequestDetail":
            debugPrint("Segue: ShowPullRequestDetail")
            guard let row = tableView.indexPathForSelectedRow?.row else {
                print("Error getting selected row")
                return
            }
            
            guard let pullRequest = pullRequests?[row] else {
                print("Error getting selected issue")
                return
            }
            
            guard let destination = segue.destination as? PullRequestDetailTableViewController else {
                print("Error getting destination view controller")
                return
            }
            
            //calcVC.rate = vatRates[row]
        default:
            debugPrint("Received unhandled segue: " + identifier)
            break
        }
    }


}
