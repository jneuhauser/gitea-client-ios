//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct Reference: Codable {
    
    public var object: GitObject?
    public var ref: String?
    public var url: String?
    
    public init(object: GitObject?, ref: String?, url: String?) { 
        self.object = object
        self.ref = ref
        self.url = url
    }
}
