//
//  IssueTableViewCell.swift
//  Gitea
//
//  Created by Johann Neuhauser on 23.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import UIKit

class IssuesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var info1Label: UILabel!
    @IBOutlet weak var info1Image: UIImageView!
    @IBOutlet weak var info2Label: UILabel!
    @IBOutlet weak var info2Image: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
