//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct EditTeamOption: Codable {
    
    public enum Permission: String, Codable { 
        case read = "read"
        case write = "write"
        case admin = "admin"
    }
    
    public var _description: String?
    public var name: String
    public var permission: Permission?
    public var units: [String]?
    
    public init(_description: String?, name: String, permission: Permission?, units: [String]?) { 
        self._description = _description
        self.name = name
        self.permission = permission
        self.units = units
    }
    
    public enum CodingKeys: String, CodingKey { 
        case _description = "description"
        case name
        case permission
        case units
    }
}
