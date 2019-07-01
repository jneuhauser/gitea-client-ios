//
//  CodeTableViewController.swift
//  Gitea
//
//  Created by Johann Neuhauser on 14.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import UIKit

class CodeTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    public var gitTreeShaToLoad: String?

    private var references: [Reference]?
    private var gitTree: GitTreeResponse?
    private var branches: [Branch]?
    private var readmeCell: MarkdownWithHeaderTableViewCell?
    private var readmeGitEntry: GitEntry? {
        didSet {
            DispatchQueue.main.async {
                self.readmeCell = self.tableView.dequeueReusableCell(withIdentifier: MarkdownWithHeaderTableViewCell.reuseIdentifier) as? MarkdownWithHeaderTableViewCell
            }
        }
    }

    private var selectedRepoHash = AppState.selectedRepo.hashValue
    private var titleImage: UIImage?
    private var selectedBranch = AppState.selectedRepo?.defaultBranch {
        didSet {
            if let selectedBranch = selectedBranch {
                selectedBranchTextField?.text = "Branch: \(selectedBranch)"
            }
        }
    }

    private var selectedBranchTextField: UITextField?
    private var branchSelectionPicker: UIPickerView?

    override func viewDidLoad() {
        super.viewDidLoad()

        if title == nil {
            title = "Code"
        }

        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 2
        tableView.register(MarkdownWithHeaderTableViewCell.uiNib, forCellReuseIdentifier: MarkdownWithHeaderTableViewCell.reuseIdentifier)

        navigationController?.navigationBar.isTranslucent = false

        if gitTreeShaToLoad != nil {
            if titleImage == nil {
                titleImage = UIImage(named: "file-directory")
            }
            if let navigationTitle = title {
                navigationItem.setTilte(navigationTitle, withImage: titleImage)
            }
            loadGitTreeAsync()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if gitTreeShaToLoad == nil,
            selectedRepoHash != AppState.selectedRepo.hashValue {
            selectedRepoHash = AppState.selectedRepo.hashValue
            selectedBranch = AppState.selectedRepo?.defaultBranch
            if titleImage == nil {
                titleImage = UIImage(named: "code")
            }
            if let repoOwner = AppState.selectedRepo?.owner?.login,
                let repoName = AppState.selectedRepo?.name {
                navigationItem.setTilte("\(repoOwner)/\(repoName)", withImage: titleImage)
            }
            loadReferencesAsync()
            loadBranchesAsync()
        }
    }

    private func loadReferencesAsync() {
        if let repoOwner = AppState.selectedRepo?.owner?.login,
            let repoName = AppState.selectedRepo?.name {
            Networking.shared.getRepositoryReferences(fromOwner: repoOwner, andRepo: repoName, filteredBy: "heads") { result in
                switch result {
                case let .success(references):
                    self.references = references
                    self.loadGitTreeAsync()
                case let .failure(error):
                    debugPrint("getRepositoryReferences() failed with \(error)")
                    DispatchQueue.main.async {
                        self.showToast(message: Networking.generateUserErrorMessage(error))
                    }
                }
            }
        }
    }

    private func loadGitTreeAsync() {
        if let selectedBranch = selectedBranch {
            let selectedBranchRef = references?.filter { ref in
                ref.ref == "refs/heads/\(selectedBranch)"
            }
            if let repoOwner = AppState.selectedRepo?.owner?.login,
                let repoName = AppState.selectedRepo?.name,
                let treeSha = gitTreeShaToLoad ?? selectedBranchRef?.first?.object?.sha {
                Networking.shared.getRepositoryGitTree(fromOwner: repoOwner, andRepo: repoName, forSha: treeSha) { result in
                    switch result {
                    case let .success(gitTree):
                        self.gitTree = gitTree
                        // Sort by name
                        self.gitTree?.tree?.sort(by: { $0.path! < $1.path! })
                        // Sort by type (tree = folder above blob = file)
                        self.gitTree?.tree?.sort(by: { $0.type! > $1.type! })
                        // Search for for a git entry of readme in md format and attach object
                        self.readmeGitEntry = self.gitTree?.tree?.filter { $0.path?.lowercased().contains("readme.md") ?? false }.first
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            self.refreshControl?.endRefreshing()
                        }
                    case let .failure(error):
                        debugPrint("getRepositoryGitTree() failed with \(error)")
                        DispatchQueue.main.async {
                            self.refreshControl?.endRefreshing()
                            self.showToast(message: Networking.generateUserErrorMessage(error))
                        }
                    }
                }
            }
        }
    }

    private func loadBranchesAsync() {
        if let repoOwner = AppState.selectedRepo?.owner?.login,
            let repoName = AppState.selectedRepo?.name {
            Networking.shared.getRepositoryBranches(fromOwner: repoOwner, andRepo: repoName) { result in
                switch result {
                case let .success(branches):
                    self.branches = branches
                    // Sort to have current selected branch as first element
                    self.branches?.sort(by: { first, _ in first.name == self.selectedBranch })
                case let .failure(error):
                    debugPrint("getRepositoryReferences() failed with \(error)")
                    DispatchQueue.main.async {
                        self.showToast(message: Networking.generateUserErrorMessage(error))
                    }
                }
            }
        }
    }

    private func loadDataModel() {
        // Load refs to determine tree sha of branch
        if gitTreeShaToLoad == nil {
            loadReferencesAsync()
            loadBranchesAsync()
        } else {
            loadGitTreeAsync()
        }
    }

    @IBAction func refreshAction(_: UIRefreshControl) {
        loadDataModel()
    }

    // MARK: - Picker view delegates

    func numberOfComponents(in _: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        return branches?.count ?? 0
    }

    func pickerView(_: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
        return branches?[row].name
    }

    func pickerView(_: UIPickerView, didSelectRow row: Int, inComponent _: Int) {
        if selectedBranch != branches?[row].name {
            selectedBranch = branches?[row].name
        }
    }

    // MARK: - Text field delegates

    func textFieldDidBeginEditing(_: UITextField) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(pickerDone))
    }

    @objc private func pickerDone() {
        view.endEditing(true)
        navigationItem.rightBarButtonItem = nil
        loadDataModel()
    }

    // MARK: - Table view delegates

    override func tableView(_: UITableView, viewForHeaderInSection _: Int) -> UIView? {
        let headerView = UIView()

        if gitTreeShaToLoad == nil {
            headerView.backgroundColor = .white

            let descriptionLabel = UILabel()
            descriptionLabel.text = AppState.selectedRepo?._description
            descriptionLabel.numberOfLines = 0
            descriptionLabel.textColor = UIColor.black
            descriptionLabel.sizeToFit()
            descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            headerView.addSubview(descriptionLabel)

            let branchPicker = UIPickerView()
            branchSelectionPicker = branchPicker
            branchPicker.dataSource = self
            branchPicker.delegate = self

            let branchSelection = UITextField()
            selectedBranchTextField = branchSelection
            branchSelection.delegate = self
            // Update text field with didSet method of property
            if let selectedBranch = selectedBranch {
                self.selectedBranch = selectedBranch
            }
            branchSelection.inputView = branchSelectionPicker
            branchSelection.textColor = .blue
            branchSelection.translatesAutoresizingMaskIntoConstraints = false
            headerView.addSubview(branchSelection)

            var constraints = [NSLayoutConstraint]()
            constraints.append(NSLayoutConstraint(item: descriptionLabel, attribute: .leading, relatedBy: .equal, toItem: headerView, attribute: .leading, multiplier: 1.0, constant: 8.0))
            constraints.append(NSLayoutConstraint(item: descriptionLabel, attribute: .trailing, relatedBy: .equal, toItem: headerView, attribute: .trailing, multiplier: 1.0, constant: -8.0))
            constraints.append(NSLayoutConstraint(item: descriptionLabel, attribute: .top, relatedBy: .equal, toItem: headerView, attribute: .top, multiplier: 1.0, constant: 8.0))
            constraints.append(NSLayoutConstraint(item: descriptionLabel, attribute: .bottom, relatedBy: .equal, toItem: branchSelection, attribute: .top, multiplier: 1.0, constant: -8.0))
            constraints.append(NSLayoutConstraint(item: branchSelection, attribute: .bottom, relatedBy: .equal, toItem: headerView, attribute: .bottom, multiplier: 1.0, constant: -8.0))
            constraints.append(NSLayoutConstraint(item: branchSelection, attribute: .leading, relatedBy: .equal, toItem: headerView, attribute: .leading, multiplier: 1.0, constant: 8.0))
            constraints.append(NSLayoutConstraint(item: branchSelection, attribute: .trailing, relatedBy: .equal, toItem: headerView, attribute: .trailing, multiplier: 1.0, constant: -8.0))
            headerView.addConstraints(constraints)
        }

        return headerView
    }

    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < (gitTree?.tree?.count ?? 0) else {
            return
        }

        guard let selectedElement = gitTree?.tree?[indexPath.row] else {
            debugPrint("tableView(cellForRowAt: ...): failed to get model data")
            return
        }

        switch selectedElement.type {
        case "blob":
            let fileQLPreviewController = FileQLPreviewController()
            fileQLPreviewController.gitEntry = selectedElement
            navigationController?.pushViewController(fileQLPreviewController, animated: true)
        case "tree":
            if let codeTableViewController = storyboard?.instantiateViewController(withIdentifier: "CodeTableViewController") as? CodeTableViewController {
                codeTableViewController.gitTreeShaToLoad = selectedElement.sha

                if let path = selectedElement.path {
                    let filePathEndIndex = path.lastIndex(of: "/") ?? path.endIndex
                    codeTableViewController.title = String(path[..<filePathEndIndex])
                }

                navigationController?.pushViewController(codeTableViewController, animated: true)
            }
        default:
            debugPrint("tableView(didSelectRowAt): unhandled element type: \(selectedElement.type ?? "nil")")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return (gitTree?.tree?.count ?? 0) + (readmeGitEntry != nil ? 1 : 0)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = gitTree?.tree?.count != indexPath.row ? tableView.dequeueReusableCell(withIdentifier: "CodeCell", for: indexPath) : readmeCell ?? tableView.dequeueReusableCell(withIdentifier: MarkdownWithHeaderTableViewCell.reuseIdentifier, for: indexPath)

        switch cell {
        case is MarkdownWithHeaderTableViewCell:
            guard let fileName = readmeGitEntry?.path,
                let fileSha = readmeGitEntry?.sha,
                let repoOwner = AppState.selectedRepo?.owner?.login,
                let repoName = AppState.selectedRepo?.name else {
                debugPrint("tableView(cellForRowAt: ...): failed to get model data")
                return cell
            }

            let tvc = cell as! MarkdownWithHeaderTableViewCell

            tvc.backgroundColor = .lightGray

            tvc.headerLabel.text = fileName

            tvc.markdownView.onRendered = { height in
                let calculatedHeight = height + tvc.headerLabel.frame.height

                // force update of table view layout
                tvc.hStackViewHeight.constant = calculatedHeight
                tableView.beginUpdates()
                tableView.endUpdates()
            }

            tvc.setupOnTouchLink(forViewController: self)

            Networking.shared.getRepositoryGitBlob(fromOwner: repoOwner, andRepo: repoName, forSha: fileSha) { result in
                switch result {
                case let .success(blob):
                    switch blob.encoding {
                    case "base64":
                        if let content = blob.content,
                            let decodedData = Data(base64Encoded: content),
                            let contentString = String(data: decodedData, encoding: .utf8) {
                            DispatchQueue.main.async {
                                tvc.markdownView.load(markdown: contentString)
                            }
                        }
                    default:
                        debugPrint("tableView(cellForRowAt ...): unhandled encoding type")
                        DispatchQueue.main.async {
                            self.showToast(message: "Unhandled encoding type")
                        }
                    }
                case let .failure(error):
                    debugPrint("getRepositoryGitBlob() failed with \(error)")
                    DispatchQueue.main.async {
                        self.showToast(message: Networking.generateUserErrorMessage(error))
                    }
                }
            }
        default:
            guard let element = gitTree?.tree?[indexPath.row] else {
                debugPrint("tableView(cellForRowAt: ...): failed to get model data")
                return cell
            }

            if let path = element.path, let type = element.type, let size = element.size {
                switch type {
                case "blob":
                    cell.imageView?.image = UIImage(named: "file")
                case "tree":
                    cell.imageView?.image = UIImage(named: "file-directory")
                default:
                    cell.imageView?.image = UIImage(named: "file-binary")
                }

                cell.textLabel?.text = path

                cell.detailTextLabel?.text = type == "tree" ? "" : size.getByteRepresentaion()
            }
        }

        return cell
    }
}
