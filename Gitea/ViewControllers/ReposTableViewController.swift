//
//  ReposTableViewController.swift
//  Gitea
//
//  Created by Johann Neuhauser on 13.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import UIKit

class ReposTableViewController: UITableViewController {
    
    private var repos: [Repository]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clearsSelectionOnViewWillAppear = false
        
        title = "Repositories"
        
        if AppState.selectedRepo == nil {
            AppState.disableOtherTabBarItems(ofTabBarController: tabBarController)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let _ = presentingViewController as? LoginViewController {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(askForLogout(_:)))
        }
        
        if repos == nil {
            loadReposAsync()
        }
    }
    
    @objc func askForLogout(_ sender: UIBarButtonItem) {
        let test = PopUpControllerGenerator.createPopUp(withTitle: "Logout", andMessage: "Are you sure you want to log out?") { _ in
            self.presentingViewController?.dismiss(animated: true)
            AppState.reset()
        }
        navigationController?.present(test, animated: true, completion: nil)
    }
    
    private func loadReposAsync() {
        Networking.shared.getRepositories() { result in
            switch result {
            case .success(let repos):
                self.repos = repos
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                }
            case .failure(let error):
                debugPrint("getRepositories() failed with \(error)")
                DispatchQueue.main.async {
                    self.refreshControl?.endRefreshing()
                    self.showToast(message: Networking.generateUserErrorMessage(error))
                }
            }
        }
    }

    @IBAction func refreshAction(_ sender: UIRefreshControl) {
        loadReposAsync()
    }
    
    // MARK: - Table view delegates
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let repo = repos?[indexPath.row] {
            AppState.selectedRepo = repo
            AppState.enableAllTabBarItems(ofTabBarController: tabBarController)
            AppState.popToRootOtherNavigationControllers(ofTabBarController: tabBarController)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell", for: indexPath)
        
        guard let repo = repos?[indexPath.row] else {
            return cell
        }

        cell.textLabel?.text = repo.fullName
        
        if let mirror = repo.mirror, mirror {
            cell.imageView?.image = UIImage(named: "repo-clone")
        } else if let fork = repo.fork, fork {
            cell.imageView?.image = UIImage(named: "repo-forked")
        } else if let _private = repo._private, _private {
            cell.imageView?.image = UIImage(named: "lock")
        } else {
            cell.imageView?.image = UIImage(named: "repo")
        }

        return cell
    }
    
}
