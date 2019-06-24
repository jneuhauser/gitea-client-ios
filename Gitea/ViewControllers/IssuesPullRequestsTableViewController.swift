//
//  IssuesPullRequestsTableViewController.swift
//  Gitea
//
//  Created by Johann Neuhauser on 13.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import UIKit

class IssuesPullRequestsTableViewController: UITableViewController {
    private var issues: [IssuePullRequestData]?

    private var selectedRepoHash = AppState.selectedRepo.hashValue

    private var loadDataAsync: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        switch AppState.getSelectedTabBarItem(fromIndex: tabBarController?.selectedIndex) {
        case .Issues:
            title = "Issues"
            loadDataAsync = loadIssuesAsync
        case .PullRequests:
            title = "Pull Requests"
            loadDataAsync = loadPullRequestsAsync
        default:
            break
        }

        tableView.register(IssuePullRequestTableViewCell.uiNib, forCellReuseIdentifier: IssuePullRequestTableViewCell.reuseIdentifier)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if selectedRepoHash != AppState.selectedRepo.hashValue {
            selectedRepoHash = AppState.selectedRepo.hashValue
            loadDataAsync?()
        }
    }

    private func loadIssuesAsync() {
        if let repoOwner = AppState.selectedRepo?.owner?.login,
            let repoName = AppState.selectedRepo?.name {
            Networking.shared.getIssues(fromOwner: repoOwner, andRepo: repoName) { result in
                switch result {
                case let .success(issues):
                    self.issues = issues.filter { issue in
                        // Filter out all pull requests
                        issue.pullRequest == nil
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.refreshControl?.endRefreshing()
                    }
                case let .failure(error):
                    debugPrint("getIssues() failed with \(error)")
                    DispatchQueue.main.async {
                        self.refreshControl?.endRefreshing()
                        self.showToast(message: Networking.generateUserErrorMessage(error))
                    }
                }
            }
        }
    }

    private func loadPullRequestsAsync() {
        if let repoOwner = AppState.selectedRepo?.owner?.login,
            let repoName = AppState.selectedRepo?.name {
            Networking.shared.getPullRequests(fromOwner: repoOwner, andRepo: repoName) { result in
                switch result {
                case let .success(pullRequests):
                    self.issues = pullRequests
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.refreshControl?.endRefreshing()
                    }
                case let .failure(error):
                    debugPrint("getPullRequests() failed with \(error)")
                    DispatchQueue.main.async {
                        self.refreshControl?.endRefreshing()
                        self.showToast(message: Networking.generateUserErrorMessage(error))
                    }
                }
            }
        }
    }

    @IBAction func refreshAction(_: UIRefreshControl) {
        loadDataAsync?()
    }

    // MARK: - Table view delegates

    override func tableView(_: UITableView, didSelectRowAt _: IndexPath) {
        performSegue(withIdentifier: "ShowIssuePullRequestDetail", sender: self)
    }

    // MARK: - Table view data source

    override func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return issues?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IssuePullRequestTableViewCell.reuseIdentifier, for: indexPath)

        guard let issue = issues?[indexPath.row] else {
            debugPrint("tableView(cellForRowAt: ...): failed to get model data")
            return cell
        }

        switch cell {
        case is IssuePullRequestTableViewCell:
            let issueTVC = cell as! IssuePullRequestTableViewCell

            switch issue {
            case is PullRequest:
                if let state = issue.state, state == .closed,
                    let pr = issue as? PullRequest,
                    let merged = pr.merged, merged {
                    issueTVC.imageView?.image = UIImage(named: "git-merge")
                } else {
                    issueTVC.imageView?.image = UIImage(named: "git-pull-request")
                }
            case is Issue:
                if let state = issue.state, state == .closed {
                    issueTVC.typeImage?.image = UIImage(named: "issue-closed")
                } else {
                    issueTVC.typeImage?.image = UIImage(named: "issue-opened")
                }
            default:
                break
            }

            issueTVC.titleLabel?.text = issue.title

            if let number = issue.number,
                let state = issue.state,
                let user = issue.user?.login,
                let createdSince = issue.createdAt?.getDifferenceToNow(withUnitCount: 1) {
                let state = state == .closed ? "closed" : "opened"
                issueTVC.footerLabel?.text = "#\(number) \(state) \(createdSince) ago by \(user)"
            } else {
                issueTVC.footerLabel?.text = nil
            }

            if let comments = issue.comments, comments > 0 {
                issueTVC.commentsLabel?.text = "💬 \(comments)"
            } else {
                issueTVC.commentsLabel?.text = nil
            }
        default:
            debugPrint("tableView(cellForRowAt: ...):  unhandled cell type")
        }

        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        guard let identifier = segue.identifier else {
            return
        }

        switch identifier {
        case "ShowIssuePullRequestDetail":
            guard let row = tableView.indexPathForSelectedRow?.row else {
                debugPrint("Error getting selected row")
                return
            }

            guard let issue = issues?[row] else {
                debugPrint("Error getting selected issue")
                return
            }

            guard let destination = segue.destination as? IssuePullRequestDetailViewController else {
                debugPrint("Error getting destination view controller")
                return
            }

            destination.mainEntry = issue
        default:
            debugPrint("Received unhandled segue: " + identifier)
        }
    }
}
