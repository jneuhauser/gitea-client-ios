//
//  FileQLPreviewController.swift
//  Gitea
//
//  Created by Johann Neuhauser on 10.06.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import QuickLook
import UIKit

class FileQLPreviewController: QLPreviewController, QLPreviewControllerDataSource, QLPreviewControllerDelegate {
    public var gitEntry: GitEntry?
    public var internalFileUrl: NSURL?

    override func viewDidLoad() {
        super.viewDidLoad()

        // fix possibly hidden content under tab bar
        tabBarController?.tabBar.isTranslucent = false

        dataSource = self
        loadFileAsync()
    }

    // MARK: Data handling

    private func loadFileAsync() {
        if let repoOwner = AppState.selectedRepo?.owner?.login,
            let repoName = AppState.selectedRepo?.name,
            let fileSha = gitEntry?.sha {
            Networking.shared.getRepositoryGitBlob(fromOwner: repoOwner, andRepo: repoName, forSha: fileSha) { result in
                switch result {
                case let .success(blob):
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
                        self.saveDataToTempDir(data, withRelativeFilePath: path) {
                        DispatchQueue.main.async {
                            self.reloadData()
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.showToast(message: "Unknown error")
                        }
                    }
                case let .failure(error):
                    debugPrint("getRepositoryGitBlob() failed with \(error)")
                    DispatchQueue.main.async {
                        self.showToast(message: Networking.generateUserErrorMessage(error))
                    }
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

    func numberOfPreviewItems(in _: QLPreviewController) -> Int {
        return internalFileUrl == nil ? 0 : 1
    }

    func previewController(_: QLPreviewController, previewItemAt _: Int) -> QLPreviewItem {
        return internalFileUrl!
    }
}
