//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct Permission: Codable {
    
    public var admin: Bool?
    public var pull: Bool?
    public var push: Bool?
    
    public init(admin: Bool?, pull: Bool?, push: Bool?) { 
        self.admin = admin
        self.pull = pull
        self.push = push
    }
}
