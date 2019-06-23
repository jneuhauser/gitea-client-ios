//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct UserHeatmapData: Codable, Equatable, Hashable {
    public var contributions: Int64?
    public var timestamp: Int64?

    public init(contributions: Int64?, timestamp: Int64?) {
        self.contributions = contributions
        self.timestamp = timestamp
    }
}
