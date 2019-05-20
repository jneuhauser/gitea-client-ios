//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct PullRequestMeta: Codable {
    
    public var merged: Bool?
    public var mergedAt: Date?
    
    public init(merged: Bool?, mergedAt: Date?) { 
        self.merged = merged
        self.mergedAt = mergedAt
    }
    
    public enum CodingKeys: String, CodingKey { 
        case merged
        case mergedAt = "merged_at"
    }
}
