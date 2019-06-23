//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct Repository: Codable, Equatable, Hashable {
    public var archived: Bool?
    public var cloneUrl: String?
    public var createdAt: Date?
    public var defaultBranch: String?
    public var _description: String?
    public var empty: Bool?
    public var fork: Bool?
    public var forksCount: Int64?
    public var fullName: String?
    public var htmlUrl: String?
    public var _id: Int64?
    public var mirror: Bool?
    public var name: String?
    public var openIssuesCount: Int64?
    public var owner: User?
    public var permissions: Permission?
    public var _private: Bool?
    public var size: Int64?
    public var sshUrl: String?
    public var starsCount: Int64?
    public var updatedAt: Date?
    public var watchersCount: Int64?
    public var website: String?

    public init(archived: Bool?, cloneUrl: String?, createdAt: Date?, defaultBranch: String?, _description: String?, empty: Bool?, fork: Bool?, forksCount: Int64?, fullName: String?, htmlUrl: String?, _id: Int64?, mirror: Bool?, name: String?, openIssuesCount: Int64?, owner: User?, permissions: Permission?, _private: Bool?, size: Int64?, sshUrl: String?, starsCount: Int64?, updatedAt: Date?, watchersCount: Int64?, website: String?) {
        self.archived = archived
        self.cloneUrl = cloneUrl
        self.createdAt = createdAt
        self.defaultBranch = defaultBranch
        self._description = _description
        self.empty = empty
        self.fork = fork
        self.forksCount = forksCount
        self.fullName = fullName
        self.htmlUrl = htmlUrl
        self._id = _id
        self.mirror = mirror
        self.name = name
        self.openIssuesCount = openIssuesCount
        self.owner = owner
        self.permissions = permissions
        self._private = _private
        self.size = size
        self.sshUrl = sshUrl
        self.starsCount = starsCount
        self.updatedAt = updatedAt
        self.watchersCount = watchersCount
        self.website = website
    }

    public enum CodingKeys: String, CodingKey {
        case archived
        case cloneUrl = "clone_url"
        case createdAt = "created_at"
        case defaultBranch = "default_branch"
        case _description = "description"
        case empty
        case fork
        case forksCount = "forks_count"
        case fullName = "full_name"
        case htmlUrl = "html_url"
        case _id = "id"
        case mirror
        case name
        case openIssuesCount = "open_issues_count"
        case owner
        case permissions
        case _private = "private"
        case size
        case sshUrl = "ssh_url"
        case starsCount = "stars_count"
        case updatedAt = "updated_at"
        case watchersCount = "watchers_count"
        case website
    }
}
