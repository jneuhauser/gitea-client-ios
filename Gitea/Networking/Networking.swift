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
    
    private func constructQueryParamString(fromParams params: [String]) -> String {
        var string = String()
        for param in params {
            if param == params.first {
                string += "?\(param)"
            } else {
                string += "&\(param)"
            }
        }
        return string
    }
    
    public func getRepositories(completionHandler: @escaping (Result<[Repository],Error>) -> Void) {
        let apiPath = "/api/v1/user/repos"
        
        guard let request = Authentication.shared.constructURLRequest(withPath: apiPath) else {
            completionHandler(Result.failure(NetworkingError.requestConstructError(apiPath)))
            return
        }
        
        let task = URLSession.jsonRequest(forResponseType: [Repository].self, withRequest: request, withMethod: .get, completionHandler: completionHandler)
        task.resume()
    }
    
    public func getIssues(
        fromOwner owner: String,
        andRepo repo: String,
        withState state: String?,
        withLabels labels: String?,
        pageNumber page: Int?,
        searchString q: String?,
        completionHandler: @escaping (Result<[Issue],Error>) -> Void)
    {
        var queryParams = [String]()
        if let state = state {
            queryParams.append("state=\(state)")
        }
        if let labels = labels {
            queryParams.append("labels=\(labels)")
        }
        if let page = page {
            queryParams.append("page=\(page)")
        }
        if let q = q {
            queryParams.append("q=\(q)")
        }
        let queryParamsString = constructQueryParamString(fromParams: queryParams)
        
        let apiPath = "/api/v1/repos/\(owner)/\(repo)/issues\(queryParamsString)"
        guard let request = Authentication.shared.constructURLRequest(withPath: apiPath) else {
            completionHandler(Result.failure(NetworkingError.requestConstructError(apiPath)))
            return
        }
        
        let task = URLSession.jsonRequest(forResponseType: [Issue].self, withRequest: request, withMethod: .get, completionHandler: completionHandler)
        task.resume()
    }
    
    public func getPullRequests(
        fromOwner owner: String,
        andRepo repo: String,
        pageNumber page: Int?,
        withState state: StateTypeOption?,
        sortedBy sort: SortTypeOption?,
        withMilestone milestone: Int?,
        withLabels labels: [Int]?,
        completionHandler: @escaping (Result<[PullRequest],Error>) -> Void)
    {
        var queryParams = [String]()
        if let page = page {
            queryParams.append("page=\(page)")
        }
        if let state = state {
            queryParams.append("state=\(state)")
        }
        if let sort = sort {
            queryParams.append("sort=\(sort)")
        }
        if let milestone = milestone {
            queryParams.append("milestone=\(milestone)")
        }
        if let labels = labels {
            for label in labels {
                queryParams.append("labels=\(label)")
            }
        }
        let queryParamsString = constructQueryParamString(fromParams: queryParams)
        
        let apiPath = "/api/v1/repos/\(owner)/\(repo)/pulls\(queryParamsString)"
        guard let request = Authentication.shared.constructURLRequest(withPath: apiPath) else {
            completionHandler(Result.failure(NetworkingError.requestConstructError(apiPath)))
            return
        }
        
        let task = URLSession.jsonRequest(forResponseType: [PullRequest].self, withRequest: request, withMethod: .get, completionHandler: completionHandler)
        task.resume()
    }
    
    public func getReleases(
        fromOwner owner: String,
        andRepo repo: String,
        pageNumber page: Int?,
        itemsPerPage perPage: Int?,
        completionHandler: @escaping (Result<[Release],Error>) -> Void)
    {
        var queryParams = [String]()
        if let page = page {
            queryParams.append("page=\(page)")
        }
        if let perPage = perPage {
            queryParams.append("per_page=\(perPage)")
        }
        let queryParamsString = constructQueryParamString(fromParams: queryParams)
        
        let apiPath = "/api/v1/repos/\(owner)/\(repo)/releases\(queryParamsString)"
        guard let request = Authentication.shared.constructURLRequest(withPath: apiPath) else {
            completionHandler(Result.failure(NetworkingError.requestConstructError(apiPath)))
            return
        }
        
        let task = URLSession.jsonRequest(forResponseType: [Release].self, withRequest: request, withMethod: .get, completionHandler: completionHandler)
        task.resume()
    }
    
    public func getIssueComments(
        fromOwner owner: String,
        andRepo repo: String,
        withIndex index: Int64,
        sinceTime since: Date?,
        completionHandler: @escaping (Result<[Comment],Error>) -> Void)
    {
        var queryParams = [String]()
        if let since = since {
            let sinceString = rfc3339DateFormatter.string(from: since)
            queryParams.append("since=\(sinceString)")
        }
        let queryParamsString = constructQueryParamString(fromParams: queryParams)
        
        let apiPath = "/api/v1/repos/\(owner)/\(repo)/issues/\(index)/comments\(queryParamsString)"
        guard let request = Authentication.shared.constructURLRequest(withPath: apiPath) else {
            completionHandler(Result.failure(NetworkingError.requestConstructError(apiPath)))
            return
        }
        
        let task = URLSession.jsonRequest(forResponseType: [Comment].self, withRequest: request, withMethod: .get, completionHandler: completionHandler)
        task.resume()
    }
}
