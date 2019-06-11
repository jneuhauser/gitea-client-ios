//
//  FileQLPreviewController.swift
//  Gitea
//
//  Created by Johann Neuhauser on 10.06.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import UIKit
import QuickLook

class FileQLPreviewController: QLPreviewController, QLPreviewControllerDataSource, QLPreviewControllerDelegate {
    
    public var gitEntry: GitEntry?
    public var internalFileUrl: NSURL?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        loadFileAsync()
    }
    
    // MARK: Data handling
    
    private func loadFileAsync() {
        if let owner = AppState.selectedRepo?.owner?.login,
            let repo = AppState.selectedRepo?.name,
            let fileSha = gitEntry?.sha {
            Networking.shared.getRepositoryGitBlob(fromOwner: owner, andRepo: repo, forSha: fileSha) { result in
                switch result {
                case .success(let blob):
                    debugPrint(blob)
                    
                    var decodedData: Data?
                    
                    switch blob.encoding {
                    case "base64":
                        if let content = blob.content {
                            decodedData = Data(base64Encoded: content)
                        }
                    default:
                        debugPrint("loadFileAsync(): unhandled encoding type")
                    }
                    
                    if let path = self.gitEntry?.path,
                        let data = decodedData,
                        self.saveDataToTempDir(data, withRelativeFilePath: path)
                    {
                        DispatchQueue.main.async {
                            self.reloadData()
                        }
                    } else {
                        // TODO: Popup message of failure
                        self.navigationController?.popViewController(animated: true)
                    }
                case .failure(let error):
                    debugPrint("getRepositoryGitBlob() failed with \(error)")
                }
            }
        }
    }
    
    private func saveDataToTempDir(_ data: Data, withRelativeFilePath path: String) -> Bool {
        do {
            let fileUrl = NSURL(fileURLWithPath: NSTemporaryDirectory() + path)
            try data.write(to: fileUrl as URL)
            internalFileUrl = fileUrl
            
            // Handle file always as text file if not previeable by known extension
            if !QLPreviewController.canPreview(fileUrl),
                let fakeUrl = fileUrl.appendingPathExtension("txt") {
                try? FileManager.default.removeItem(at: fakeUrl)
                try FileManager.default.moveItem(at: fileUrl as URL, to: fakeUrl)
                internalFileUrl = fakeUrl as NSURL
            }
            
            return true
        } catch {
            debugPrint(error)
        }
        return false
    }
    
    // MARK: Quick Look data source
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return internalFileUrl == nil ? 0 : 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return internalFileUrl!
    }
}
