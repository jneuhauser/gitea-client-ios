//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct IssueDeadline: Codable, Equatable, Hashable {
    public var dueDate: Date?

    public init(dueDate: Date?) {
        self.dueDate = dueDate
    }

    public enum CodingKeys: String, CodingKey {
        case dueDate = "due_date"
    }
}
