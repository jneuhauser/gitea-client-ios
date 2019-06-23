//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct CreateRepoOption: Codable, Equatable, Hashable {
    public var autoInit: Bool?
    public var _description: String?
    public var gitignores: String?
    public var license: String?
    public var name: String
    public var _private: Bool?
    public var readme: String?

    public init(autoInit: Bool?, _description: String?, gitignores: String?, license: String?, name: String, _private: Bool?, readme: String?) {
        self.autoInit = autoInit
        self._description = _description
        self.gitignores = gitignores
        self.license = license
        self.name = name
        self._private = _private
        self.readme = readme
    }

    public enum CodingKeys: String, CodingKey {
        case autoInit = "auto_init"
        case _description = "description"
        case gitignores
        case license
        case name
        case _private = "private"
        case readme
    }
}
