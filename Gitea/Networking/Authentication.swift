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
    
    private var serverUrl: URL?
    private var userName: String?
    private var authHeaderValue: String?
    
    public func setServer(fromString string: String) -> Bool {
        if let url = URL(string: string) {
            self.serverUrl = url
            return true
        }
        return false
    }
    
    public func setAuthentication(withUser user: String, andPassword password: String) {
        self.userName = user
        let basicAuth = "\(user):\(password)"
        self.authHeaderValue = "Basic \(basicAuth.getBase64())"
    }
    
    public func constructURLRequest(withPath string: String) -> URLRequest? {
        guard let url = URL(string: string, relativeTo: self.serverUrl) else {
            debugPrint("Authentication.constructURLRequest(\"\(string)\"): error constructing URL!")
            return nil
        }
        var request = URLRequest(url: url)
        if let authHeaderValue = self.authHeaderValue {
            request.addValue(authHeaderValue, forHTTPHeaderField: "Authorization")
        }
        return request
    }
}
