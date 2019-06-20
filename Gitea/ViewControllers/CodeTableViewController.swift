//
//  CodeTableViewController.swift
//  Gitea
//
//  Created by Johann Neuhauser on 14.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import UIKit

class CodeTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    // Set this var to load this specific tree
    public var gitTreeShaToLoad: String?
    
    private var references: [Reference]?
    private var gitTree: GitTreeResponse?
    private var branches: [Branch]?
    private var readmeGitEntry: GitEntry?
    
    private var selectedRepoHash = AppState.selectedRepo.hashValue
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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        if title == nil {
            title = "Code"
        }
        
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 2
        tableView.register(MarkdownWithHeaderTableViewCell.uiNib, forCellReuseIdentifier: MarkdownWithHeaderTableViewCell.reuseIdentifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let loginViewController = presentingViewController as? LoginViewController {
            // TODO: Setup logout button
            //loginViewController.dismiss(animated: true)
            debugPrint("My presenting view controller is: \(loginViewController)")
        }
        
        if gitTreeShaToLoad != nil {
            loadGitTreeAsync()
        } else
            
        if selectedRepoHash != AppState.selectedRepo.hashValue {
            selectedRepoHash = AppState.selectedRepo.hashValue
            selectedBranch = AppState.selectedRepo?.defaultBranch
            loadReferencesAsync()
            loadBranchesAsync()
        }
    }
    
    private func loadReferencesAsync() {
        if let repoOwner = AppState.selectedRepo?.owner?.login,
            let repoName = AppState.selectedRepo?.name {
            Networking.shared.getRepositoryReferences(fromOwner: repoOwner, andRepo: repoName, filteredBy: "heads") { result in
                switch result {
                case .success(let references):
                    debugPrint(references)
                    self.references = references
                    self.loadGitTreeAsync()
                case .failure(let error):
                    debugPrint("getRepositoryReferences() failed with \(error)")
                }
            }
        }
    }
    
    private func loadGitTreeAsync() {
        if let selectedBranch = selectedBranch {
            let selectedBranchRef = references?.filter() { ref in
                return ref.ref == "refs/heads/\(selectedBranch)"
            }
            if let repoOwner = AppState.selectedRepo?.owner?.login,
                let repoName = AppState.selectedRepo?.name,
                let treeSha = gitTreeShaToLoad ?? selectedBranchRef?.first?.object?.sha {
                Networking.shared.getRepositoryGitTree(fromOwner: repoOwner, andRepo: repoName, forSha: treeSha) { result in
                    switch result {
                    case .success(let gitTree):
                        debugPrint(gitTree)
                        self.gitTree = gitTree
                        // Sort by name
                        self.gitTree?.tree?.sort(by: { return $0.path! < $1.path! })
                        // Sort by type (tree = folder above blob = file)
                        self.gitTree?.tree?.sort(by: { return $0.type! > $1.type! })
                        // Search for for a git entry of readme in md format and attach object
                        self.readmeGitEntry = self.gitTree?.tree?.filter({ return $0.path?.lowercased().contains("readme.md") ?? false }).first
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            self.refreshControl?.endRefreshing()
                        }
                    case .failure(let error):
                        debugPrint("getRepositoryGitTree() failed with \(error)")
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
                case .success(let branches):
                    debugPrint(branches)
                    self.branches = branches
                    // Sort to have current selected branch as first element
                    self.branches?.sort(by: { first, _ in return first.name == self.selectedBranch })
                case .failure(let error):
                    debugPrint("getRepositoryReferences() failed with \(error)")
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

    @IBAction func refreshAction(_ sender: UIRefreshControl) {
        loadDataModel()
    }
    
    @objc func selectBranchAction(_ sender: Any?) {
        debugPrint("selectBranchAction(...): called")
    }
    
    // MARK: - Picker view delegates
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return branches?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return branches?[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if selectedBranch != branches?[row].name {
            selectedBranch = branches?[row].name
        }
    }
    
    // MARK: - Text field delegates
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(pickerDone))
    }
    
    @objc func pickerDone() {
        self.view.endEditing(true)
        self.navigationItem.rightBarButtonItem = nil
        loadDataModel()
    }
    
    // MARK: - Table view delegates
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        if gitTreeShaToLoad == nil {
            let descriptionLabel = UILabel()
            descriptionLabel.text = AppState.selectedRepo?._description
            descriptionLabel.numberOfLines = 0
            descriptionLabel.textColor = UIColor.black
            descriptionLabel.sizeToFit()
            // property translatesAutoresizingMaskIntoConstraints should be false to use auto layout for dynamic size
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedElement = gitTree?.tree?[indexPath.row] else {
            return
        }
        
        switch selectedElement.type {
        case "blob":
            debugPrint("tableView(didSelectRowAt): blob type selected")
            let fileQLPreviewController = FileQLPreviewController()
            fileQLPreviewController.gitEntry = selectedElement
            // TODO: setup vc to not overlap with tabbar ???
            navigationController?.pushViewController(fileQLPreviewController, animated: true)
        case "tree":
            debugPrint("tableView(didSelectRowAt): tree type selected")
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (gitTree?.tree?.count ?? 0) + (readmeGitEntry != nil ? 1 : 0)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = gitTree?.tree?.count != indexPath.row ? tableView.dequeueReusableCell(withIdentifier: "CodeCell", for: indexPath) : tableView.dequeueReusableCell(withIdentifier: MarkdownWithHeaderTableViewCell.reuseIdentifier, for: indexPath)
        
        switch cell {
        case is MarkdownWithHeaderTableViewCell:
            let tvc = cell as! MarkdownWithHeaderTableViewCell
            
            if let fileName = readmeGitEntry?.path,
                let fileSha = readmeGitEntry?.sha,
                let repoOwner = AppState.selectedRepo?.owner?.login,
                let repoName = AppState.selectedRepo?.name {
                
                tvc.backgroundColor = .lightGray
                
                tvc.headerLabel.text = fileName
            
                tvc.markdownView.onRendered = { height in
                    let calculatedHeight = height + tvc.headerLabel.frame.height
                    
                    // force update of table view layout
                    tvc.hStackViewHeight.constant = calculatedHeight
                    tableView.beginUpdates()
                    tableView.endUpdates()
                }
            
                Networking.shared.getRepositoryGitBlob(fromOwner: repoOwner, andRepo: repoName, forSha: fileSha) { result in
                    switch result {
                    case .success(let blob):
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
                        }
                    case .failure(let error):
                        debugPrint("getRepositoryGitBlob() failed with \(error)")
                    }
                }
            }
        default:
            guard let element = gitTree?.tree?[indexPath.row] else {
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
