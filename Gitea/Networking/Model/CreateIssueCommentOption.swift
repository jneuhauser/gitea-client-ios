//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct CreateIssueCommentOption: Codable, Equatable, Hashable {
    
    public var body: String
    
    public init(body: String) { 
        self.body = body
    }
}
