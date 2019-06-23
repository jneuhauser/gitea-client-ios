//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct AddCollaboratorOption: Codable, Equatable, Hashable {
    public var permission: String?

    public init(permission: String?) {
        self.permission = permission
    }
}
