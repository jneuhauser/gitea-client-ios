//
//  IssueDetailWithMarkdownViewTableViewCell.swift
//  Gitea
//
//  Created by Johann Neuhauser on 02.06.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import MarkdownView
import SafariServices
import UIKit

class MarkdownWithHeaderTableViewCell: UITableViewCell {
    public static let reuseIdentifier: String = String(describing: self)
    public static let uiNib: UINib = UINib(nibName: "MarkdownWithHeaderTableViewCell", bundle: nil)

    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var markdownView: MarkdownView!
    @IBOutlet var hStackViewHeight: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()

        markdownView.isScrollEnabled = false

        markdownView.onRendered = { height in
            self.hStackViewHeight.constant = height + self.headerLabel.frame.height
        }
    }

    override func prepareForReuse() {
        markdownView.onRendered = nil
    }

    public func setupOnTouchLink(forViewController vc: UIViewController) {
        markdownView.onTouchLink = { request in
            guard let url = request.url else { return false }

            if url.scheme == "https" || url.scheme == "http" {
                let webViewController = WKWebViewViewController()
                webViewController.load(url)
                vc.navigationController?.pushViewController(webViewController, animated: true)
                return false
            } else if url.scheme == "mailto" {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                } else {
                    // Fallback on earlier versions
                    UIApplication.shared.openURL(url)
                }
                return false
            } else if url.scheme == "file" {
                debugPrint("Local file preview not implemented for now")
                return false
            } else {
                debugPrint("Unhandled url scheme: \(url.scheme ?? "not set")")
                return false
            }
        }
    }
}
