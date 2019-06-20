//
//  IssuePullRequestDetailViewController.swift
//  Gitea
//
//  Created by Johann Neuhauser on 19.06.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import UIKit
import MessageViewController

class IssuePullRequestDetailViewController: MessageViewController, UITableViewDelegate, UITableViewDataSource {
    
    public var mainEntry: IssuePullRequestDelegate?
    private var comments: [Comment]?
    private var rowHeights = [Int : CGFloat]()
    
    let tableView = UITableView()
    let refreshControl: UIRefreshControl? = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let number = mainEntry?.number, let title = mainEntry?.title {
            self.title = "#\(number) - \(title)"
        }
        
        refreshControl?.addTarget(self, action: #selector(refreshAction(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "MarkdownWithHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "MarkdownWithHeaderCellFromNib")
//        tableView.register(UINib(nibName: "IssueDetailSimpleTableViewCell", bundle: nil), forCellReuseIdentifier: "IssueDetailSimpleCellFromNib")
//        tableView.register(UINib(nibName: "WebViewTableViewCell", bundle: nil), forCellReuseIdentifier: "WebViewCellFromNib")
        view.addSubview(tableView)
        
        borderColor = .lightGray
        
        messageView.inset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 16)
        messageView.font = UIFont.systemFont(ofSize: 18)
        
        messageView.setButton(title: "Add", for: .normal, position: .left)
        messageView.addButton(target: self, action: #selector(onLeftButton), position: .left)
        messageView.leftButtonTint = .blue
        messageView.showLeftButton = true
        
        messageView.setButton(inset: 10, position: .left)
        messageView.setButton(inset: 15, position: .right)
        
        messageView.textView.placeholderText = "New message..."
        messageView.textView.placeholderTextColor = .lightGray
        
        messageView.setButton(title: "Send", for: .normal, position: .right)
        messageView.addButton(target: self, action: #selector(onRightButton), position: .right)
        messageView.rightButtonTint = .blue
        
        setup(scrollView: tableView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Load comments only if not loaded before and if there are comments
        if comments == nil, let commentCount = mainEntry?.comments, commentCount > 0 {
            loadCommentsAsync()
        }
    }
    
    private func loadCommentsAsync() {
        if let repoOwner = AppState.selectedRepo?.owner?.login,
            let repoName = AppState.selectedRepo?.name,
            let issueIndex = mainEntry?.number {
            Networking.shared.getIssueComments(fromOwner: repoOwner, andRepo: repoName, withIndex: issueIndex) { result in
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
        }
    }
    
    @objc func refreshAction(_ sender: UIRefreshControl) {
        loadCommentsAsync()
    }
    
    @objc func onLeftButton() {
        debugPrint("Did press left button")
        // TODO: Implement comment post preview
    }
    
    @objc func onRightButton() {
        debugPrint("Did press right button")
        debugPrint(messageView.text)
        // TODO: Implement comment post call
        if let commentCount = comments?.count {
            tableView.scrollToRow(
                at: IndexPath(row: commentCount - 1, section: 0),
                at: .bottom,
                animated: true
            )
        }
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (mainEntry == nil ? 0 : 1) + (comments?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeights[indexPath.row] ?? tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        
        switch cell {
        case is MarkdownWithHeaderTableViewCell:
            let tvc = cell as! MarkdownWithHeaderTableViewCell
            tvc.headerLabel.text = header
            if let rowHeight = rowHeights[indexPath.row] {
                debugPrint("saved calculated row(\(indexPath.row)) height: \(rowHeight)")
                tvc.hStackViewHeight.constant = rowHeight
            }
            tvc.markdownView.onRendered = { height in
                let newCalculatedHeight = height + tvc.headerLabel.frame.height
                debugPrint("new calculated row(\(indexPath.row)) height: \(newCalculatedHeight)")
                // Update saved value if not existent or if it has changed
                if self.rowHeights[indexPath.row] == nil ||
                    self.rowHeights[indexPath.row] != newCalculatedHeight {
                    self.rowHeights[indexPath.row] = newCalculatedHeight
                    tvc.hStackViewHeight.constant = newCalculatedHeight
                    tableView.beginUpdates()
                    tableView.endUpdates()
                }
            }
            tvc.markdownView.load(markdown: body)
//        case is IssueDetailSimpleTableViewCell:
//            let tvc = cell as! IssueDetailSimpleTableViewCell
//            tvc.headerLabel.text = header
//            tvc.contentAttributedLabel.text = body
//        case is WebViewTableViewCell:
//            let tvc = cell as! WebViewTableViewCell
//            if var request = Authentication.shared.constructURLRequest(withPath: "/api/v1/markdown/raw") {
//                request.httpMethod = "POST"
//                request.httpBody = body.data(using: .utf8)
//                
//                tvc.webView.tag = indexPath.row
//                tvc.webView.load(request)
//                
//                // use already calculated height
//                if let webViewHeight = rowHeights[indexPath.row] {
//                    tvc.webViewHeightConstraint.constant = webViewHeight
//                }
//                
//                // we have a generic callback, so set it only if it´s not set
//                if tvc.webViewResizeCallback == nil {
//                    tvc.webViewResizeCallback = { tag, height in
//                        debugPrint("webViewResizeCallback(tag = \(tag), height): \(height)): called")
//                        // update cell layouts without cell reload
//                        // TODO: do this only once for all cells???
//                        tableView.beginUpdates()
//                        tableView.endUpdates()
//                        // save hight for later use
//                        self.rowHeights[tag] = height
//                    }
//                }
//            }
        default:
            debugPrint("tableView(cellForRowAt: ...):  unhandled cell type")
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
}
