//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct Branch: Codable {
    
    public var commit: PayloadCommit?
    public var name: String?
    
    public init(commit: PayloadCommit?, name: String?) { 
        self.commit = commit
        self.name = name
    }
}
