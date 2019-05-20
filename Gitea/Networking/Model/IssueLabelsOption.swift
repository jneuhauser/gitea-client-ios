//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct IssueLabelsOption: Codable {
    
    public var labels: [Int64]?
    
    public init(labels: [Int64]?) { 
        self.labels = labels
    }
}
