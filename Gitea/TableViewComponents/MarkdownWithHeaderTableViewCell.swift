//
//  IssueDetailWithMarkdownViewTableViewCell.swift
//  Gitea
//
//  Created by Johann Neuhauser on 02.06.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import UIKit
import MarkdownView
import SafariServices

class MarkdownWithHeaderTableViewCell: UITableViewCell {
    
    public static let reuseIdentifier: String = String(describing: self)
    public static let uiNib: UINib = UINib(nibName: "MarkdownWithHeaderTableViewCell", bundle: nil)
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var markdownView: MarkdownView!
    @IBOutlet weak var hStackViewHeight: NSLayoutConstraint!
    
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
                let safari = SFSafariViewController(url: url)
                vc.present(safari, animated: true)
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
