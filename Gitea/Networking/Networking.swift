//
//  Networking.swift
//  Gitea
//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

class Networking {
    // Singleton
    public static let shared = Networking()
    private init() {}
    
    enum NetworkingError: Error {
        case requestConstructError(String)
    }
    
    public func getRepositories(completionHandler: @escaping (Result<[Repo],Error>) -> Void) {
        let apiPath = "/api/v1/user/repos"
        guard let request = Authentication.shared.constructURLRequest(withPath: apiPath) else {
            completionHandler(Result.failure(NetworkingError.requestConstructError(apiPath)))
            return
        }
        let task = URLSession.jsonRequest([Repo].self, withRequest: request, withMethod: .get, completionHandler: completionHandler)
        task.resume()
    }
}
