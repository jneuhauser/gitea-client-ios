//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct Team: Codable {
    
    public enum Permission: String, Codable { 
        case _none = "none"
        case read = "read"
        case write = "write"
        case admin = "admin"
        case owner = "owner"
    }
    
    public enum Units: String, Codable {
        case repoCode = "repo.code"
        case repoIssues = "repo.issues"
        case repoExtIssues = "repo.ext_issues"
        case repoWiki = "repo.wiki"
        case repoPulls = "repo.pulls"
        case repoReleases = "repo.releases"
        case repoExtWiki = "repo.ext_wiki"
    }
    
    public var _description: String?
    public var _id: Int64?
    public var name: String?
    public var organization: Organization?
    public var permission: Permission?
    public var units: [Units]?
    
    public init(_description: String?, _id: Int64?, name: String?, organization: Organization?, permission: Permission?, units: [Units]?) { 
        self._description = _description
        self._id = _id
        self.name = name
        self.organization = organization
        self.permission = permission
        self.units = units
    }
    
    public enum CodingKeys: String, CodingKey { 
        case _description = "description"
        case _id = "id"
        case name
        case organization
        case permission
        case units
    }
}
