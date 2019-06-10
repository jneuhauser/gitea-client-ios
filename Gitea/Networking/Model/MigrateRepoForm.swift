//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct MigrateRepoForm: Codable, Equatable, Hashable {
    
    public var authPassword: String?
    public var authUsername: String?
    public var cloneAddr: String
    public var _description: String?
    public var mirror: Bool?
    public var _private: Bool?
    public var repoName: String
    public var uid: Int64
    
    public init(authPassword: String?, authUsername: String?, cloneAddr: String, _description: String?, mirror: Bool?, _private: Bool?, repoName: String, uid: Int64) { 
        self.authPassword = authPassword
        self.authUsername = authUsername
        self.cloneAddr = cloneAddr
        self._description = _description
        self.mirror = mirror
        self._private = _private
        self.repoName = repoName
        self.uid = uid
    }
    
    public enum CodingKeys: String, CodingKey { 
        case authPassword = "auth_password"
        case authUsername = "auth_username"
        case cloneAddr = "clone_addr"
        case _description = "description"
        case mirror
        case _private = "private"
        case repoName = "repo_name"
        case uid
    }
}
