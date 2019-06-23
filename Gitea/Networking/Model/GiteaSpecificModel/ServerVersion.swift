//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct ServerVersion: Codable, Equatable, Hashable {
    public var version: String?

    public init(version: String?) {
        self.version = version
    }
}
