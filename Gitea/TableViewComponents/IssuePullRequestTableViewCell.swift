//
//  IssuePullRequestTableViewCell.swift
//  Gitea
//
//  Created by Johann Neuhauser on 23.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import UIKit

class IssuePullRequestTableViewCell: UITableViewCell {
    
    public static let reuseIdentifier: String = String(describing: self)
    public static let uiNib: UINib = UINib(nibName: "IssuePullRequestTableViewCell", bundle: nil)
    
    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var footerLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!

}
