//
//  CodeTableViewController.swift
//  Gitea
//
//  Created by Johann Neuhauser on 14.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import UIKit

class CodeTableViewController: UITableViewController {
    
    // Set this var to load this specific tree
    public var gitTreeShaToLoad: String?
    
    private var references: [Reference]?
    private var gitTree: GitTreeResponse?
    
    private var selectedRepoHash = AppState.selectedRepo.hashValue
    private var selectedBranch = AppState.selectedRepo?.defaultBranch

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
        }
    }
    
    private func loadReferencesAsync() {
        if let owner = AppState.selectedRepo?.owner?.login,
            let name = AppState.selectedRepo?.name {
            Networking.shared.getRepositoryReferences(fromOwner: owner, andRepo: name, filteredBy: "heads") { result in
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
            if let owner = AppState.selectedRepo?.owner?.login,
                let name = AppState.selectedRepo?.name,
                let sha = gitTreeShaToLoad ?? selectedBranchRef?.first?.object?.sha {
                Networking.shared.getRepositoryGitTree(fromOwner: owner, andRepo: name, forSha: sha) { result in
                    switch result {
                    case .success(let gitTree):
                        debugPrint(gitTree)
                        self.gitTree = gitTree
                        // Sort by name
                        self.gitTree?.tree?.sort(by: { return $0.path! < $1.path! })
                        // Sort by type (tree = folder above blob = file)
                        self.gitTree?.tree?.sort(by: { return $0.type! > $1.type! })
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

    @IBAction func refreshAction(_ sender: UIRefreshControl) {
        if gitTreeShaToLoad == nil {
            loadReferencesAsync()
        } else {
            loadGitTreeAsync()
        }
    }
    
    @objc func selectBranchAction(_ sender: Any?) {
        debugPrint("selectBranchAction(...): called")
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
            
            let branchSelection = UIButton()
            branchSelection.setTitle("Branch: \(AppState.selectedRepo!.defaultBranch!)", for: .normal)
            branchSelection.setTitleColor(UIColor.black, for: .normal)
            branchSelection.layer.borderColor = UIColor.darkGray.cgColor
            branchSelection.addTarget(self, action: #selector(selectBranchAction(_:)), for: .touchUpInside)
            // property translatesAutoresizingMaskIntoConstraints should be false to use auto layout for dynamic size
            branchSelection.translatesAutoresizingMaskIntoConstraints = false
            headerView.addSubview(branchSelection)
            
            var constraints = [NSLayoutConstraint]()
            constraints.append(NSLayoutConstraint(item: descriptionLabel, attribute: .leading, relatedBy: .equal, toItem: headerView, attribute: .leading, multiplier: 1.0, constant: 8.0))
            constraints.append(NSLayoutConstraint(item: descriptionLabel, attribute: .trailing, relatedBy: .equal, toItem: headerView, attribute: .trailing, multiplier: 1.0, constant: 8.0))
            constraints.append(NSLayoutConstraint(item: descriptionLabel, attribute: .top, relatedBy: .equal, toItem: headerView, attribute: .top, multiplier: 1.0, constant: 4.0))
            constraints.append(NSLayoutConstraint(item: branchSelection, attribute: .top, relatedBy: .equal, toItem: descriptionLabel, attribute: .bottom, multiplier: 1.0, constant: 4.0))
            constraints.append(NSLayoutConstraint(item: branchSelection, attribute: .leading, relatedBy: .equal, toItem: headerView, attribute: .leading, multiplier: 1.0, constant: 0))
            constraints.append(NSLayoutConstraint(item: branchSelection, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 38))
            constraints.append(NSLayoutConstraint(item: branchSelection, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 200))
            constraints.append(NSLayoutConstraint(item: branchSelection, attribute: .bottom, relatedBy: .equal, toItem: headerView, attribute: .bottom, multiplier: 1.0, constant: 4.0))
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
        // #warning Incomplete implementation, return the number of rows
        return gitTree?.tree?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CodeCell", for: indexPath)
        
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
            
//            let filePathEndIndex = path.lastIndex(of: "/") ?? path.startIndex
//            // Cut of "/" for the file name if there was a file path
//            let fileNameStartIndex = filePathEndIndex == path.startIndex ? filePathEndIndex : path.index(after: filePathEndIndex)
//            cell.textLabel?.text = String(path[fileNameStartIndex...])
            cell.textLabel?.text = path
            
            cell.detailTextLabel?.text = type == "tree" ? "" : size.getByteRepresentaion()
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
