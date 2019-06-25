//
//  IssuePullRequestTableViewCell.swift
//  Gitea
//
//  Created by Johann Neuhauser on 23.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import UIKit

class IssuePullRequestTableViewCell: UITableViewCell {
    public static let reuseIdentifier: String = String(describing: IssuePullRequestTableViewCell.self)
    public static let uiNib: UINib = UINib(nibName: "IssuePullRequestTableViewCell", bundle: nil)

    @IBOutlet var typeImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var footerLabel: UILabel!
    @IBOutlet var commentsLabel: UILabel!
}
