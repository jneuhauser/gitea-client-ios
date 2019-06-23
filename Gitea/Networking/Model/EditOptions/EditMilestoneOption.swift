//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct EditMilestoneOption: Codable, Equatable, Hashable {
    public var _description: String?
    public var dueOn: Date?
    public var state: String?
    public var title: String?

    public init(_description: String?, dueOn: Date?, state: String?, title: String?) {
        self._description = _description
        self.dueOn = dueOn
        self.state = state
        self.title = title
    }

    public enum CodingKeys: String, CodingKey {
        case _description = "description"
        case dueOn = "due_on"
        case state
        case title
    }
}
