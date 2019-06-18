//
//  IssuePullRequestDetailTableViewController.swift
//  Gitea
//
//  Created by Johann Neuhauser on 28.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import UIKit

class IssuePullRequestDetailTableViewController: UITableViewController {
    
    public var mainEntry: IssuePullRequestDelegate?
    private var comments: [Comment]?
    private var rowHeights = [Int : CGFloat]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.register(UINib(nibName: "IssueDetailSimpleTableViewCell", bundle: nil), forCellReuseIdentifier: "IssueDetailSimpleCellFromNib")
        tableView.register(UINib(nibName: "WebViewTableViewCell", bundle: nil), forCellReuseIdentifier: "WebViewCellFromNib")
        tableView.register(UINib(nibName: "MarkdownWithHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "MarkdownWithHeaderCellFromNib")
        tableView.register(WriteCommentTableViewFooter.self, forHeaderFooterViewReuseIdentifier: WriteCommentTableViewFooter.reuseIdentifier)
        
        if let number = mainEntry?.number, let title = mainEntry?.title {
            self.title = "#\(number) - \(title)"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Load comments only if not loaded before
        if comments == nil {
            loadCommentsAsync()
        }
    }
    
    private func loadCommentsAsync() {
        // Do nothing if there are no comments
        // TODO: How should we update the current issue? Or should we always try to load the issue comments?
        if let comments = mainEntry?.comments, comments > 0,
            let issueIndex = mainEntry?.number {
            // TODO: Load the comments of the selected repo
            Networking.shared.getIssueComments(fromOwner: "devel", andRepo: "test1-cpp", withIndex: issueIndex) { result in
                switch result {
                case .success(let comments):
                    debugPrint(comments)
                    self.comments = comments
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.refreshControl?.endRefreshing()
                    }
                case .failure(let error):
                    debugPrint("getIssueComments() failed with \(error)")
                }
            }
        } else {
            // TODO: refresh the main entry
            self.refreshControl?.endRefreshing()
        }
    }
    
    @IBAction func refreshAction(_ sender: UIRefreshControl) {
        loadCommentsAsync()
        // force also a recalc of the cell heights
        // TODO: it should be better to check for changed size instead of recal of all cell heights
        //rowHeights.removeAll(keepingCapacity: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // main entry and the number of comments
        return (mainEntry == nil ? 0 : 1) + (comments?.count ?? 0)
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
            loginO = mainEntry?.user?.login
            createdSinceO = mainEntry?.createdAt?.getDifferenceToNow(withUnitCount: 1)
            bodyO = mainEntry?.body
        } else {
            loginO = comments?[indexPath.row - 1].user?.login
            createdSinceO = comments?[indexPath.row - 1].createdAt?.getDifferenceToNow(withUnitCount: 1)
            bodyO = comments?[indexPath.row - 1].body
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
            if let rowHeight = rowHeights[indexPath.row] {
                debugPrint("Set height to: \(rowHeight)")
                tvc.hStackViewHeight.constant = rowHeight
                // TODO: it should be better to check for changed size
                tvc.markdownView.onRendered = nil
            } else {
                tvc.markdownView.onRendered = { height in
                    debugPrint("markdownView.onRendered(height = \(height)")
                    tvc.hStackViewHeight.constant = height + tvc.headerLabel.frame.height
                    tableView.beginUpdates()
                    tableView.endUpdates()
                    self.rowHeights[indexPath.row] = height + tvc.headerLabel.frame.height
                }
            }
            tvc.markdownView.load(markdown: body)
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
                        debugPrint("webViewResizeCallback(tag = \(tag), height): \(height)): called")
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
    
    // Use table view header for issue / pr title
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if let title = mainEntry?.title,
//            let number = mainEntry?.number {
//            return "#\(number) - \(title)"
//        }
//        return nil
//    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: WriteCommentTableViewFooter.reuseIdentifier) as? WriteCommentTableViewFooter else {
            debugPrint("tableView(viewForFooterInSection): error dequeueing view")
            return nil
        }
        
        view.image.image = UIImage(named: "comment")
        view.title.text = "Write a comment"
        
        debugPrint(view)
        
        return view
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
