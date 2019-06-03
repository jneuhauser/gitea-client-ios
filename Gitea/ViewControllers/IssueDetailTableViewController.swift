//
//  IssueDetailTableViewController.swift
//  Gitea
//
//  Created by Johann Neuhauser on 28.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import UIKit

class IssueDetailTableViewController: UITableViewController {
    
    public var issue: Issue?
    private var issueComments: [Comment]?
    private var rowHeights = [Int : CGFloat]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.register(UINib(nibName: "IssueDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "IssueDetailCellFromNib")
        tableView.register(UINib(nibName: "IssueDetailSimpleTableViewCell", bundle: nil), forCellReuseIdentifier: "IssueDetailSimpleCellFromNib")
        tableView.register(UINib(nibName: "WebViewTableViewCell", bundle: nil), forCellReuseIdentifier: "WebViewCellFromNib")
        tableView.register(UINib(nibName: "MarkdownWithHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "MarkdownWithHeaderCellFromNib")
    }
    
    @IBAction func refreshAction(_ sender: UIRefreshControl) {
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // issue and the number of comments
        return (issue == nil ? 0 : 1) + (issueComments?.count ?? 0)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Check if we have a calculated row height value, else return the default one
        return rowHeights[indexPath.row] ?? tableView.rowHeight
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MarkdownWithHeaderCellFromNib", for: indexPath)
        
        var loginO: String?
        var createdSinceO: String?
        var bodyO: String?
        
        if indexPath.row == 0 {
            loginO = issue?.user?.login
            createdSinceO = issue?.createdAt?.getDifferenceToNow(withUnitCount: 1)
            bodyO = issue?.body
        } else {
            loginO = issueComments?[indexPath.row - 1].user?.login
            createdSinceO = issueComments?[indexPath.row - 1].createdAt?.getDifferenceToNow(withUnitCount: 1)
            bodyO = issueComments?[indexPath.row - 1].body
        }
        
        guard let login = loginO, let createdSince = createdSinceO, let body = bodyO else {
            debugPrint("tableView(cellForRowAt: ...): failed to get all data values")
            return cell
        }
        
        let header = "\(login) commented \(createdSince) ago"
        debugPrint(header)
        
        // Fill the cell
        switch cell {
        case is MarkdownWithHeaderTableViewCell:
            let tvc = cell as! MarkdownWithHeaderTableViewCell
            tvc.headerLabel.text = header
//            if let rowHeight = rowHeights[indexPath.row] {
//                debugPrint("Set height to: \(rowHeight)")
//                tvc.markdownViewHeightConstraint.constant = rowHeight
//                tvc.markdownView.onRendered = nil
//            } else {
                tvc.markdownView.onRendered = { height in
                    debugPrint("markdownView.onRendered(height = \(height)")
                    tvc.markdownViewHeightConstraint.constant = height
                    tableView.beginUpdates()
                    tableView.endUpdates()
//                    self.rowHeights[indexPath.row] = height
//                }
            }
            tvc.markdownView.load(markdown: body)
        case is IssueDetailTableViewCell:
            let tvc = cell as! IssueDetailTableViewCell
            tvc.headerLabel.text = header
            // TODO: Fill web view
        case is IssueDetailSimpleTableViewCell:
            let tvc = cell as! IssueDetailSimpleTableViewCell
            tvc.headerLabel.text = header
            tvc.contentAttributedLabel.text = body
        case is WebViewTableViewCell:
            let tvc = cell as! WebViewTableViewCell
            if var request = Authentication.shared.constructURLRequest(withPath: "/api/v1/markdown/raw") {
                request.httpMethod = "POST"
                request.httpBody = body.data(using: .utf8)
                
                tvc.webView.tag = indexPath.row
                tvc.webView.load(request)
                
                // use already calculated height
                if let webViewHeight = rowHeights[indexPath.row] {
                    tvc.webViewHeightConstraint.constant = webViewHeight
                }
                
                // we have a generic callback, so set it only if it´s not set
                if tvc.webViewResizeCallback == nil {
                    tvc.webViewResizeCallback = { tag, height in
                        debugPrint("webViewResizeCallback(tag = \(tag), height: \(height)): called")
                        // update cell layouts without cell reload
                        // TODO: do this only once for all cells???
                        tableView.beginUpdates()
                        tableView.endUpdates()
                        // save hight for later use
                        self.rowHeights[tag] = height
                    }
                }
            }
        default:
            // This properties does have all table view cells
            cell.textLabel?.text = header
            cell.detailTextLabel?.text = body
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
