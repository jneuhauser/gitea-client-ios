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
    
    public func getRepositories(onSuccess: @escaping ([Repo]) -> Void, onFailure: @escaping (Error) -> Void) {
        let apiPath = "/api/v1/user/repos"
        guard let request = Authentication.shared.constructURLRequest(withPath: apiPath) else {
            onFailure(NetworkingError.requestConstructError(apiPath))
            return
        }
        
        let task = URLSession.jsonRequest([Repo].self, withRequest: request, withMethod: .get) { result in
            switch result {
            case .success(let success):
                debugPrint(success)
                onSuccess(success)
            case .failure(let failure):
                debugPrint(failure)
                onFailure(failure)
            }
        }
        task.resume()
    }
}
