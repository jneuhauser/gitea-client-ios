//
//  Created by Johann Neuhauser on 20.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public enum StatusState: String, Codable, Equatable, Hashable {
    case pending
    case success
    case error
    case failure
    case warning
}
