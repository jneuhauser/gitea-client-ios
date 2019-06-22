//
//  IssueDetailSimpleTableViewCell.swift
//  Gitea
//
//  Created by Johann Neuhauser on 31.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import UIKit

class IssueDetailSimpleTableViewCell: UITableViewCell {
    
    public static let reuseIdentifier: String = String(describing: self)
    public static let uiNib: UINib = UINib(nibName: "IssueDetailSimpleTableViewCell", bundle: nil)
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var contentAttributedLabel: UILabel!
    
}
