//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct CreateKeyOption: Codable, Equatable, Hashable {
    
    public var key: String
    public var readOnly: Bool?
    public var title: String
    
    public init(key: String, readOnly: Bool?, title: String) { 
        self.key = key
        self.readOnly = readOnly
        self.title = title
    }
    
    public enum CodingKeys: String, CodingKey { 
        case key
        case readOnly = "read_only"
        case title
    }
}
