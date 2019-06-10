//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct User: Codable, Equatable {
    
    public var avatarUrl: String?
    public var email: String?
    public var fullName: String?
    public var _id: Int64?
    public var isAdmin: Bool?
    public var language: String?
    public var login: String?
    
    public init(avatarUrl: String?, email: String?, fullName: String?, _id: Int64?, isAdmin: Bool?, language: String?, login: String?) { 
        self.avatarUrl = avatarUrl
        self.email = email
        self.fullName = fullName
        self._id = _id
        self.isAdmin = isAdmin
        self.language = language
        self.login = login
    }
    
    public enum CodingKeys: String, CodingKey { 
        case avatarUrl = "avatar_url"
        case email
        case fullName = "full_name"
        case _id = "id"
        case isAdmin = "is_admin"
        case language
        case login
    }
}
