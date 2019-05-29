//
//  IssuesTableViewController.swift
//  Gitea
//
//  Created by Johann Neuhauser on 13.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import UIKit

class IssuesTableViewController: UITableViewController {
    
    private var issues: [Issue]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.navigationController?.navigationBar.topItem?.title = "Issues"
        
        tableView.register(UINib(nibName: "IssueTableViewCell", bundle: nil), forCellReuseIdentifier: "IssueCellFromNib")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let loginViewController = presentingViewController as? LoginViewController {
            // TODO: Setup logout button
            //loginViewController.dismiss(animated: true)
            debugPrint("My presenting view controller is: \(loginViewController)")
        }
        
        // Load issues data only if not loaded before
        if issues == nil {
            loadIssuesAsync()
        }
    }
    
    private func loadIssuesAsync() {
        // TODO: Load the isses of the selected repo
        Networking.shared.getIssues(fromOwner: "devel", andRepo: "test1-cpp", withState: nil, withLabels: nil, pageNumber: nil, searchString: nil) { result in
            switch result {
            case .success(let issues):
                debugPrint(issues)
                self.issues = issues
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                }
            case .failure(let error):
                debugPrint("getIssues() failed with \(error)")
            }
        }
    }

    @IBAction func refreshAction(_ sender: UIRefreshControl) {
        loadIssuesAsync()
    }
    
    // MARK: - Table view delegates
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowIssueDetail", sender: self)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return issues?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IssueCellFromNib", for: indexPath)
        
        guard let issue = issues?[indexPath.row] else {
            return cell
        }
        
        if let issueTVC = cell as? IssueTableViewCell {
            if let state = issue.state, state == .closed {
                issueTVC.typeImage?.image = UIImage(named: "issue-closed")
            } else {
                issueTVC.typeImage?.image = UIImage(named: "issue-opened")
            }
            
            issueTVC.titleLabel?.text = issue.title
            
            if let number = issue.number,
                let state = issue.state,
                let user = issue.user?.login,
                let createdSince = issue.createdAt?.getDifferenceToNow(withUnitCount: 1) {
                let state = state == .closed ? "closed" : "opened"
                debugPrint(createdSince)
                issueTVC.footerLabel?.text = "#\(number) \(state) \(createdSince) ago by \(user)"
            } else {
                issueTVC.footerLabel?.text = nil
            }
            
            if let comments = issue.comments, comments > 0 {
                issueTVC.commentsLabel?.text = "💬 \(comments)"
            } else {
                issueTVC.commentsLabel?.text = nil
            }
        } else {
            cell.textLabel?.text = issue.title
            
            if let state = issue.state {
                switch state {
                case .open:
                    cell.imageView?.image = UIImage(named: "issue-opened")
                case .closed:
                    cell.imageView?.image = UIImage(named: "issue-closed")
                }
            } else {
                cell.imageView?.image = UIImage(named: "issue-opened")
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
        case "ShowIssueDetail":
            debugPrint("Segue: ShowIssueDetail")
            guard let row = tableView.indexPathForSelectedRow?.row else {
                print("Error getting selected row")
                return
            }
            
            guard let issue = issues?[row] else {
                print("Error getting selected issue")
                return
            }
            
            guard let destination = segue.destination as? IssueDetailTableViewController else {
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
