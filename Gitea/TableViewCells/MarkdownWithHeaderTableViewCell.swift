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
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var markdownView: MarkdownView!
    @IBOutlet weak var markdownViewHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        markdownView.isScrollEnabled = false

        markdownView.onRendered = { height in
            self.markdownViewHeightConstraint.constant = height
        }
        
//        markdownView.onTouchLink = { [weak self] request in
//            guard let url = request.url else { return false }
//
//            if url.scheme == "file" {
//                return true
//            } else if url.scheme == "https" {
//                let safari = SFSafariViewController(url: url)
//                self?.present(safari, animated: true, completion: nil)
//                return false
//            } else {
//                return false
//            }
//        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
