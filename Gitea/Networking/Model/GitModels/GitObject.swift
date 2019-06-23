//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct GitObject: Codable, Equatable, Hashable {
    public var sha: String?
    public var type: String?
    public var url: String?

    public init(sha: String?, type: String?, url: String?) {
        self.sha = sha
        self.type = type
        self.url = url
    }
}
