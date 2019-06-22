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
    
    // Improve performance of cell height determination
    typealias RowHeightForContent = (rowHeight: CGFloat, contentHashValue: Int)
    private var rowHeights = [Int : RowHeightForContent]()
    
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
        tableView.register(MarkdownWithHeaderTableViewCell.uiNib, forCellReuseIdentifier: MarkdownWithHeaderTableViewCell.reuseIdentifier)
        // altetnate markdown rendering solutions
//        tableView.register(IssueDetailSimpleTableViewCell.uiNib, forCellReuseIdentifier: IssueDetailSimpleTableViewCell.reuseIdentifier)
//        tableView.register(WebViewTableViewCell.uiNib, forCellReuseIdentifier: WebViewTableViewCell.reuseIdentifier)
        view.addSubview(tableView)
        
        borderColor = .lightGray
        
        messageView.setButton(title: "MD", for: .normal, position: .left)
        messageView.addButton(target: self, action: #selector(onPreviewButton), position: .left)
        messageView.leftButtonTint = .blue
        messageView.setButton(inset: 0, position: .left)
        messageView.showLeftButton = true
        
        messageView.setButton(title: "Send", for: .normal, position: .right)
        messageView.addButton(target: self, action: #selector(onSendButton), position: .right)
        messageView.rightButtonTint = .blue
        messageView.setButton(inset: 0, position: .right)
        
        messageView.inset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        messageView.font = UIFont.systemFont(ofSize: 18)
        messageView.textView.placeholderText = "New message..."
        messageView.textView.placeholderTextColor = .lightGray
        
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
                    DispatchQueue.main.async {
                        self.refreshControl?.endRefreshing()
                        self.showToast(message: Networking.generateUserErrorMessage(error))
                    }
                }
            }
        }
    }
    
    @objc func refreshAction(_ sender: UIRefreshControl) {
        loadCommentsAsync()
    }
    
    @objc func onPreviewButton() {
        debugPrint("Did press preview button")
    }
    
    @objc func onSendButton() {
        debugPrint("Did press send button")
        debugPrint(messageView.text)
        
        if let repoOwner = AppState.selectedRepo?.owner?.login,
            let repoName = AppState.selectedRepo?.name,
            let issueNumber = mainEntry?.number {
            Networking.shared.addCommentToIssue(withIndex: issueNumber, ofRepo: repoName, andOwner: repoOwner, forComment: CreateIssueCommentOption(body: messageView.text)) { result in
                switch(result) {
                case .success(let comment):
                    self.comments?.append(comment)
                    DispatchQueue.main.async {
                        if let commentsCount = self.comments?.count {
                            let lastIndexPath = IndexPath(row: commentsCount - 1, section: 0)
                            self.tableView.reloadData()
                            self.tableView.scrollToRow(
                                at: lastIndexPath,
                                at: .bottom,
                                animated: true
                            )
                        }
                        self.messageView.text = ""
                    }
                case .failure(let error):
                    debugPrint("addCommentToIssue() failed with \(error)")
                    DispatchQueue.main.async {
                        self.refreshControl?.endRefreshing()
                        self.showToast(message: Networking.generateUserErrorMessage(error))
                    }
                }
            }
        }
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (mainEntry == nil ? 0 : 1) + (comments?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeights[indexPath.row]?.rowHeight ?? tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MarkdownWithHeaderTableViewCell.reuseIdentifier, for: indexPath)
        // altetnate markdown rendering solutions
//        let cell = tableView.dequeueReusableCell(withIdentifier: IssueDetailSimpleTableViewCell.reuseIdentifier, for: indexPath)
//        let cell = tableView.dequeueReusableCell(withIdentifier: WebViewTableViewCell.reuseIdentifier, for: indexPath)
        
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
            
            let bodyHashValue = body.hashValue
            if let rowHeight = rowHeights[indexPath.row],
                rowHeight.contentHashValue == bodyHashValue {
                // use saved row height
                tvc.hStackViewHeight.constant = rowHeight.rowHeight
            } else {
                tvc.markdownView.onRendered = { height in
                    let calculatedHeight = height + tvc.headerLabel.frame.height
                    
                    // save row height and content hash value
                    var rowHeight: RowHeightForContent
                    rowHeight.rowHeight = calculatedHeight
                    rowHeight.contentHashValue = bodyHashValue
                    self.rowHeights[indexPath.row] = rowHeight
                    
                    // force update of table view layout
                    tvc.hStackViewHeight.constant = calculatedHeight
                    tableView.beginUpdates()
                    tableView.endUpdates()
                }
            }

            tvc.markdownView.load(markdown: body)
        // altetnate markdown rendering solutions
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
