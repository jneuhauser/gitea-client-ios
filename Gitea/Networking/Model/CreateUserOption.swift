//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct CreateUserOption: Codable {
    
    public var email: String
    public var fullName: String?
    public var loginName: String?
    public var mustChangePassword: Bool?
    public var password: String
    public var sendNotify: Bool?
    public var sourceId: Int64?
    public var username: String
    
    public init(email: String, fullName: String?, loginName: String?, mustChangePassword: Bool?, password: String, sendNotify: Bool?, sourceId: Int64?, username: String) { 
        self.email = email
        self.fullName = fullName
        self.loginName = loginName
        self.mustChangePassword = mustChangePassword
        self.password = password
        self.sendNotify = sendNotify
        self.sourceId = sourceId
        self.username = username
    }
    
    public enum CodingKeys: String, CodingKey { 
        case email
        case fullName = "full_name"
        case loginName = "login_name"
        case mustChangePassword = "must_change_password"
        case password
        case sendNotify = "send_notify"
        case sourceId = "source_id"
        case username
    }
}
