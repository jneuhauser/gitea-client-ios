//
//  Created by Johann Neuhauser on 10.06.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct GitBlobResponse: Codable, Equatable, Hashable {
    
    let content: String?
    let encoding: String?
    let sha: String?
    let size: Int64?
    let url: String?
    
    public init(content: String?, encoding: String?, sha: String?, size: Int64?, url: String) {
        self.content = content
        self.encoding = encoding
        self.sha = sha
        self.size = size
        self.url = url
    }
}
