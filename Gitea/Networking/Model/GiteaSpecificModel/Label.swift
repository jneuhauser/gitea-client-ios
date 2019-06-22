//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct Label: Codable, Equatable, Hashable {
    
    public var color: String?
    public var _id: Int64?
    public var name: String?
    public var url: String?
    
    public init(color: String?, _id: Int64?, name: String?, url: String?) { 
        self.color = color
        self._id = _id
        self.name = name
        self.url = url
    }
    
    public enum CodingKeys: String, CodingKey { 
        case color
        case _id = "id"
        case name
        case url
    }
}
