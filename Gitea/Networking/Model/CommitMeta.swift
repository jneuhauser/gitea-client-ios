//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct CommitMeta: Codable {
    
    public var sha: String?
    public var url: String?
    
    public init(sha: String?, url: String?) { 
        self.sha = sha
        self.url = url
    }
}
