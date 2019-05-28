//
//  IssueDetailTableViewCell.swift
//  Gitea
//
//  Created by Johann Neuhauser on 28.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import UIKit
import WebKit

class IssueDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var fullSizeHeaderLabel: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var contentWebView: WKWebView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
