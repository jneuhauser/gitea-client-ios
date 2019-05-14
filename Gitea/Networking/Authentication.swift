//
//  Authentication.swift
//  Gitea
//
//  Created by Johann Neuhauser on 14.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

class Authentication {
    // Singleton
    public static let shared = Authentication()
    private init() {}
    
    public var userIsAuthetnicated: Bool = false
    
    public func isUserAuthenticated() -> Bool {
        return userIsAuthetnicated
    }
}
