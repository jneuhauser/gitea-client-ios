//
//  IssueDetailSimpleTableViewCell.swift
//  Gitea
//
//  Created by Johann Neuhauser on 31.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import UIKit

class IssueDetailSimpleTableViewCell: UITableViewCell {
    public static let reuseIdentifier: String = String(describing: IssueDetailSimpleTableViewCell.self)
    public static let uiNib: UINib = UINib(nibName: "IssueDetailSimpleTableViewCell", bundle: nil)

    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var contentAttributedLabel: UILabel!
}
