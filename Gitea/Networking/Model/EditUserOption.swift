//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct EditUserOption: Codable {
    
    public var active: Bool?
    public var admin: Bool?
    public var allowCreateOrganization: Bool?
    public var allowGitHook: Bool?
    public var allowImportLocal: Bool?
    public var email: String
    public var fullName: String?
    public var location: String?
    public var loginName: String?
    public var maxRepoCreation: Int64?
    public var mustChangePassword: Bool?
    public var password: String?
    public var prohibitLogin: Bool?
    public var sourceId: Int64?
    public var website: String?
    
    public init(active: Bool?, admin: Bool?, allowCreateOrganization: Bool?, allowGitHook: Bool?, allowImportLocal: Bool?, email: String, fullName: String?, location: String?, loginName: String?, maxRepoCreation: Int64?, mustChangePassword: Bool?, password: String?, prohibitLogin: Bool?, sourceId: Int64?, website: String?) { 
        self.active = active
        self.admin = admin
        self.allowCreateOrganization = allowCreateOrganization
        self.allowGitHook = allowGitHook
        self.allowImportLocal = allowImportLocal
        self.email = email
        self.fullName = fullName
        self.location = location
        self.loginName = loginName
        self.maxRepoCreation = maxRepoCreation
        self.mustChangePassword = mustChangePassword
        self.password = password
        self.prohibitLogin = prohibitLogin
        self.sourceId = sourceId
        self.website = website
    }
    
    public enum CodingKeys: String, CodingKey { 
        case active
        case admin
        case allowCreateOrganization = "allow_create_organization"
        case allowGitHook = "allow_git_hook"
        case allowImportLocal = "allow_import_local"
        case email
        case fullName = "full_name"
        case location
        case loginName = "login_name"
        case maxRepoCreation = "max_repo_creation"
        case mustChangePassword = "must_change_password"
        case password
        case prohibitLogin = "prohibit_login"
        case sourceId = "source_id"
        case website
    }
}
