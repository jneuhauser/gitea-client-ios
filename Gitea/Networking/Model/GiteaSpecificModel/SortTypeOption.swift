//
//  Created by Johann Neuhauser on 20.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public enum SortTypeOption: String, Codable, Equatable, Hashable {
    case oldest = "oldest"
    case recentupdate = "recentupdate"
    case leastupdate = "leastupdate"
    case mostcomment = "mostcomment"
    case leastcomment = "leastcomment"
    case priority = "priority"
}
