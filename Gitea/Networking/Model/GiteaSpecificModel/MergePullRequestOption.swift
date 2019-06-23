//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct MergePullRequestOption: Codable, Equatable, Hashable {
    public enum Do: String, Codable {
        case merge
        case rebase
        case rebaseMerge = "rebase-merge"
        case squash
    }

    public var _do: Do
    public var mergeMessageField: String?
    public var mergeTitleField: String?

    public init(_do: Do, mergeMessageField: String?, mergeTitleField: String?) {
        self._do = _do
        self.mergeMessageField = mergeMessageField
        self.mergeTitleField = mergeTitleField
    }

    public enum CodingKeys: String, CodingKey {
        case _do = "Do"
        case mergeMessageField = "MergeMessageField"
        case mergeTitleField = "MergeTitleField"
    }
}
