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
}
