//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct SearchResults: Codable {
    
    public var data: [Repository]?
    public var ok: Bool?
    
    public init(data: [Repository]?, ok: Bool?) { 
        self.data = data
        self.ok = ok
    }
}
