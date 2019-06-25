//
//  ReposTableViewController.swift
//  Gitea
//
//  Created by Johann Neuhauser on 13.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import UIKit

class ReposTableViewController: UITableViewController, UISearchBarDelegate {
    private var repos: [Repository]? {
        get {
            var reposFiltered: [Repository]?

            if let reposFilter = reposFilter {
                reposFiltered = reposData?.filter(reposFilter)
            } else {
                reposFiltered = reposData
            }

            if let reposSearchText = reposSearchText {
                reposFiltered = reposFiltered?.filter {
                    $0.name?.lowercased().contains(reposSearchText.lowercased()) ?? false
                }
            }

            return reposFiltered
        }
        set(newValue) {
            reposData = newValue
        }
    }

    private var reposData: [Repository]?
    private var reposFilter: ((Repository) -> Bool)? {
        didSet {
            tableView.reloadData()
        }
    }

    private var reposSearchText: String? {
        didSet {
            tableView.reloadData()
        }
    }

    private var filterAllButton: UIButton?
    private var filterSourceButton: UIButton?
    private var filterForkButton: UIButton?
    private var filterMirrorButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()

        clearsSelectionOnViewWillAppear = false

        title = "Repositories"

        navigationItem.rightBarButtonItems = [UIBarButtonItem]()
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(toggleSearchBar))
        navigationItem.rightBarButtonItems?.append(searchButton)

        if presentingViewController is LoginViewController {
            let logoutButton = UIBarButtonItem(image: UIImage(named: "sign-out"), style: .plain, target: self, action: #selector(askForLogout(_:)))
            navigationItem.rightBarButtonItems?.append(logoutButton)
        }

        if AppState.selectedRepo == nil {
            AppState.disableOtherTabBarItems(ofTabBarController: tabBarController)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if repos == nil {
            loadReposAsync()
        }
    }

    @objc private func toggleSearchBar() {
        guard #available(iOS 11.0, *) else {
            showToast(message: "Search only available on iOS 11 and above")
            return
        }

        if navigationItem.searchController == nil {
            let sc = UISearchController(searchResultsController: nil)
            sc.searchBar.delegate = self
            sc.searchBar.autocapitalizationType = .none
            sc.searchBar.autocorrectionType = .no
            definesPresentationContext = true
            navigationItem.searchController = sc
            navigationItem.hidesSearchBarWhenScrolling = false
            sc.searchBar.becomeFirstResponder()
        } else {
            reposSearchText = nil
            navigationItem.searchController = nil
        }
    }

    @objc private func askForLogout(_: UIBarButtonItem) {
        let test = PopUpControllerGenerator.createPopUp(withTitle: "Logout", andMessage: "Are you sure you want to log out?") { _ in
            self.presentingViewController?.dismiss(animated: true)
            AppState.reset()
        }
        navigationController?.present(test, animated: true, completion: nil)
    }

    private func loadReposAsync() {
        Networking.shared.getRepositories { result in
            switch result {
            case let .success(repos):
                self.repos = repos.sorted {
                    // Sort by repo owner and if same than by repo name
                    if $0.owner?.login ?? "" < $1.owner?.login ?? "" {
                        return true
                    } else if $0.owner?.login ?? "" == $1.owner?.login ?? "" {
                        return $0.name ?? "" < $1.name ?? ""
                    }
                    return false
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                }
            case let .failure(error):
                debugPrint("getRepositories() failed with \(error)")
                DispatchQueue.main.async {
                    self.refreshControl?.endRefreshing()
                    self.showToast(message: Networking.generateUserErrorMessage(error))
                }
            }
        }
    }

    @IBAction func refreshAction(_: UIRefreshControl) {
        loadReposAsync()
    }

    @objc private func filterButtonActions(_ sender: UIButton?) {
        switch sender {
        case filterAllButton:
            reposFilter = nil
        case filterSourceButton:
            reposFilter = { !($0.fork ?? false) && !($0.mirror ?? false) }
        case filterForkButton:
            reposFilter = { $0.fork ?? false }
        case filterMirrorButton:
            reposFilter = { $0.mirror ?? false }
        default:
            debugPrint("filterButtonActions(...): Unhandled button")
        }
    }

    // MARK: UISearchBarDelegate

    func searchBar(_: UISearchBar, textDidChange searchText: String) {
        reposSearchText = searchText != "" ? searchText : nil
    }

    func searchBarCancelButtonClicked(_: UISearchBar) {
        reposSearchText = nil
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.text = reposSearchText
    }

    // MARK: - Table view delegates

    override func tableView(_: UITableView, viewForHeaderInSection _: Int) -> UIView? {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false

        let headerView = UIView()
        headerView.backgroundColor = .white
        headerView.addSubview(stackView)

        var constraints = [NSLayoutConstraint]()
        constraints.append(NSLayoutConstraint(item: stackView, attribute: .leading, relatedBy: .equal, toItem: headerView, attribute: .leading, multiplier: 1.0, constant: 8.0))
        constraints.append(NSLayoutConstraint(item: stackView, attribute: .trailing, relatedBy: .equal, toItem: headerView, attribute: .trailing, multiplier: 1.0, constant: -8.0))
        constraints.append(NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: headerView, attribute: .top, multiplier: 1.0, constant: 12.0))
        constraints.append(NSLayoutConstraint(item: stackView, attribute: .bottom, relatedBy: .equal, toItem: headerView, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        headerView.addConstraints(constraints)

        let allButton = UIButton(type: .roundedRect)
        allButton.setTitle(" All", for: .normal)
        allButton.setImage(UIImage(named: "globe"), for: .normal)
        allButton.translatesAutoresizingMaskIntoConstraints = false
        allButton.addTarget(self, action: #selector(filterButtonActions(_:)), for: .touchUpInside)
        stackView.addArrangedSubview(allButton)
        filterAllButton = allButton

        let sourceButton = UIButton(type: .roundedRect)
        sourceButton.setTitle(" Source", for: .normal)
        sourceButton.setImage(UIImage(named: "repo"), for: .normal)
        sourceButton.translatesAutoresizingMaskIntoConstraints = false
        sourceButton.addTarget(self, action: #selector(filterButtonActions(_:)), for: .touchUpInside)
        stackView.addArrangedSubview(sourceButton)
        filterSourceButton = sourceButton

        let forkButton = UIButton(type: .roundedRect)
        forkButton.setTitle(" Fork", for: .normal)
        forkButton.setImage(UIImage(named: "repo-forked"), for: .normal)
        forkButton.translatesAutoresizingMaskIntoConstraints = false
        forkButton.addTarget(self, action: #selector(filterButtonActions(_:)), for: .touchUpInside)
        stackView.addArrangedSubview(forkButton)
        filterForkButton = forkButton

        let mirrorButton = UIButton(type: .roundedRect)
        mirrorButton.setTitle(" Mirror", for: .normal)
        mirrorButton.setImage(UIImage(named: "repo-clone"), for: .normal)
        mirrorButton.translatesAutoresizingMaskIntoConstraints = false
        mirrorButton.addTarget(self, action: #selector(filterButtonActions(_:)), for: .touchUpInside)
        stackView.addArrangedSubview(mirrorButton)
        filterMirrorButton = mirrorButton

        return headerView
    }

    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let repo = repos?[indexPath.row] {
            AppState.selectedRepo = repo
            AppState.enableAllTabBarItems(ofTabBarController: tabBarController)
            AppState.popToRootOtherNavigationControllers(ofTabBarController: tabBarController)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return repos?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell", for: indexPath)

        guard let repo = repos?[indexPath.row] else {
            debugPrint("tableView(cellForRowAt: ...): failed to get model data")
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
