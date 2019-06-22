//
//  ReleasesTableViewController.swift
//  Gitea
//
//  Created by Johann Neuhauser on 13.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import UIKit

class ReleasesTableViewController: UITableViewController {
    
    private var releases: [Release]?
    
    private var selectedRepoHash = AppState.selectedRepo.hashValue

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Releases"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if selectedRepoHash != AppState.selectedRepo.hashValue {
            selectedRepoHash = AppState.selectedRepo.hashValue
            loadReleasesAsync()
        }
    }
    
    private func loadReleasesAsync() {
        if let repoOwner = AppState.selectedRepo?.owner?.login,
            let repoName = AppState.selectedRepo?.name {
            Networking.shared.getReleases(fromOwner: repoOwner, andRepo: repoName) { result in
                switch result {
                case .success(let releases):
                    debugPrint(releases)
                    self.releases = releases
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.refreshControl?.endRefreshing()
                    }
                case .failure(let error):
                    debugPrint("getReleases() failed with \(error)")
                    DispatchQueue.main.async {
                        self.refreshControl?.endRefreshing()
                        self.showToast(message: Networking.generateUserErrorMessage(error))
                    }
                }
            }
        }
    }

    @IBAction func refreshAction(_ sender: UIRefreshControl) {
        loadReleasesAsync()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return releases?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReleaseCell", for: indexPath)
        
        guard let release = releases?[indexPath.row] else {
            return cell
        }
        
        cell.textLabel?.text = "\(release.tagName ?? "") - \(release.name ?? "")"
        cell.imageView?.image = UIImage(named: "tag")
        
        return cell
    }

}
