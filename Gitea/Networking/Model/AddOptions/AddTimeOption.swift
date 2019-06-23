//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct AddTimeOption: Codable, Equatable, Hashable {
    public var time: Int64

    public init(time: Int64) {
        self.time = time
    }
}
