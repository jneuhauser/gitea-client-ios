//
//  Created by Johann Neuhauser on 20.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public enum SortTypeOption: String, Codable, Equatable, Hashable {
    case oldest
    case recentupdate
    case leastupdate
    case mostcomment
    case leastcomment
    case priority
}
