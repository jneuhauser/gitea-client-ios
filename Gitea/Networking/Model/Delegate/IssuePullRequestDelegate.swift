//
//  IssuePullRequestDelegate.swift
//  Gitea
//
//  Created by Johann Neuhauser on 06.06.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

protocol IssuePullRequestDelegate {
    var body: String? { get }
    var comments: Int64? { get }
    var createdAt: Date? { get }
    var number: Int64? { get }
    var title: String? { get }
    var user: User? { get }
}
