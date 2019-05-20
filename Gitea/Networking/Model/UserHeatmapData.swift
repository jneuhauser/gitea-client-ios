//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct UserHeatmapData: Codable {
    
    public var contributions: Int64?
    public var timestamp: TimeStamp?
    
    public init(contributions: Int64?, timestamp: TimeStamp?) { 
        self.contributions = contributions
        self.timestamp = timestamp
    }
}
