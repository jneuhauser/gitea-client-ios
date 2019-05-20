//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct Organization: Codable {
    
    public var avatarUrl: String?
    public var _description: String?
    public var fullName: String?
    public var _id: Int64?
    public var location: String?
    public var username: String?
    public var website: String?
    
    public init(avatarUrl: String?, _description: String?, fullName: String?, _id: Int64?, location: String?, username: String?, website: String?) { 
        self.avatarUrl = avatarUrl
        self._description = _description
        self.fullName = fullName
        self._id = _id
        self.location = location
        self.username = username
        self.website = website
    }
    
    public enum CodingKeys: String, CodingKey { 
        case avatarUrl = "avatar_url"
        case _description = "description"
        case fullName = "full_name"
        case _id = "id"
        case location
        case username
        case website
    }
}
