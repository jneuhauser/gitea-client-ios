//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct EditHookOption: Codable, Equatable, Hashable {
    public var active: Bool?
    public var config: [String: String]?
    public var events: [String]?

    public init(active: Bool?, config: [String: String]?, events: [String]?) {
        self.active = active
        self.config = config
        self.events = events
    }
}
