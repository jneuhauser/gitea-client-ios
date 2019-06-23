//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct CreateHookOption: Codable, Equatable, Hashable {
    public enum ModelType: String, Codable {
        case gitea
        case gogs
        case slack
        case discord
    }

    public var active: Bool?
    public var config: [String: String]
    public var events: [String]?
    public var type: ModelType

    public init(active: Bool?, config: [String: String], events: [String]?, type: ModelType) {
        self.active = active
        self.config = config
        self.events = events
        self.type = type
    }
}
