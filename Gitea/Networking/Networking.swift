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

    public static func generateUserErrorMessage(_ error: Error) -> String {
        return "Network error: \(error)"
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

    public func getRepositories(completionHandler: @escaping (Result<[Repository], Error>) -> Void) {
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
        withState state: String? = nil,
        withLabels labels: String? = nil,
        pageNumber page: Int? = nil,
        searchString q: String? = nil,
        completionHandler: @escaping (Result<[Issue], Error>) -> Void
    ) {
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
        pageNumber page: Int? = nil,
        withState state: StateTypeOption? = nil,
        sortedBy sort: SortTypeOption? = nil,
        withMilestone milestone: Int? = nil,
        withLabels labels: [Int]? = nil,
        completionHandler: @escaping (Result<[PullRequest], Error>) -> Void
    ) {
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
        pageNumber page: Int? = nil,
        itemsPerPage perPage: Int? = nil,
        completionHandler: @escaping (Result<[Release], Error>) -> Void
    ) {
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
        sinceTime since: Date? = nil,
        completionHandler: @escaping (Result<[Comment], Error>) -> Void
    ) {
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

    public func getRepositoryReferences(
        fromOwner owner: String,
        andRepo repo: String,
        filteredBy ref: String? = nil,
        completionHandler: @escaping (Result<[Reference], Error>) -> Void
    ) {
        let refPathParam = ref == nil ? "" : "/\(ref!)"
        let apiPath = "/api/v1/repos/\(owner)/\(repo)/git/refs\(refPathParam)"
        guard let request = Authentication.shared.constructURLRequest(withPath: apiPath) else {
            completionHandler(Result.failure(NetworkingError.requestConstructError(apiPath)))
            return
        }

        let task = URLSession.jsonRequest(forResponseType: [Reference].self, withRequest: request, withMethod: .get, completionHandler: completionHandler)
        task.resume()
    }

    public func getRepositoryBranches(
        fromOwner owner: String,
        andRepo repo: String,
        completionHandler: @escaping (Result<[Branch], Error>) -> Void
    ) {
        let apiPath = "/api/v1/repos/\(owner)/\(repo)/branches"
        guard let request = Authentication.shared.constructURLRequest(withPath: apiPath) else {
            completionHandler(Result.failure(NetworkingError.requestConstructError(apiPath)))
            return
        }

        let task = URLSession.jsonRequest(forResponseType: [Branch].self, withRequest: request, withMethod: .get, completionHandler: completionHandler)
        task.resume()
    }

    public func getRepositoryGitTree(
        fromOwner owner: String,
        andRepo repo: String,
        forSha sha: String,
        asRecursive recursive: Bool? = nil,
        pageNumber page: Int? = nil,
        itemsPerPage perPage: Int? = nil,
        completionHandler: @escaping (Result<GitTreeResponse, Error>) -> Void
    ) {
        var queryParams = [String]()
        if let recursive = recursive {
            let recursiveString = String(recursive)
            queryParams.append("recursive=\(recursiveString)")
        }
        if let page = page {
            queryParams.append("page=\(page)")
        }
        if let perPage = perPage {
            queryParams.append("per_page=\(perPage)")
        }
        let queryParamsString = constructQueryParamString(fromParams: queryParams)

        let apiPath = "/api/v1/repos/\(owner)/\(repo)/git/trees/\(sha)\(queryParamsString)"
        guard let request = Authentication.shared.constructURLRequest(withPath: apiPath) else {
            completionHandler(Result.failure(NetworkingError.requestConstructError(apiPath)))
            return
        }

        let task = URLSession.jsonRequest(forResponseType: GitTreeResponse.self, withRequest: request, withMethod: .get, completionHandler: completionHandler)
        task.resume()
    }

    public func getRepositoryGitBlob(
        fromOwner owner: String,
        andRepo repo: String,
        forSha sha: String,
        completionHandler: @escaping (Result<GitBlobResponse, Error>) -> Void
    ) {
        let apiPath = "/api/v1/repos/\(owner)/\(repo)/git/blobs/\(sha)"
        guard let request = Authentication.shared.constructURLRequest(withPath: apiPath) else {
            completionHandler(Result.failure(NetworkingError.requestConstructError(apiPath)))
            return
        }

        let task = URLSession.jsonRequest(forResponseType: GitBlobResponse.self, withRequest: request, withMethod: .get, completionHandler: completionHandler)
        task.resume()
    }

    public func getRepositoryFile(
        fromOwner owner: String,
        andRepo repo: String,
        forFilePath filePath: String,
        completionHandler: @escaping (Result<Data, Error>) -> Void
    ) {
        let apiPath = "/api/v1/repos/\(owner)/\(repo)/raw/\(filePath)"
        guard let request = Authentication.shared.constructURLRequest(withPath: apiPath) else {
            completionHandler(Result.failure(NetworkingError.requestConstructError(apiPath)))
            return
        }

        let task = URLSession.jsonRequest(forResponseType: Data.self, withRequest: request, withMethod: .get, completionHandler: completionHandler)
        task.resume()
    }

    public func addCommentToIssue(
        withIndex index: Int64,
        ofRepo repo: String,
        andOwner owner: String,
        forComment comment: CreateIssueCommentOption,
        completionHandler: @escaping (Result<Comment, Error>) -> Void
    ) {
        let apiPath = "/api/v1/repos/\(owner)/\(repo)/issues/\(index)/comments"
        guard let request = Authentication.shared.constructURLRequest(withPath: apiPath) else {
            completionHandler(Result.failure(NetworkingError.requestConstructError(apiPath)))
            return
        }

        let task = URLSession.jsonRequest(forResponseType: Comment.self, withRequest: request, withMethod: .post, withBody: comment, completionHandler: completionHandler)
        task.resume()
    }

    public func getAuhtenticatedUser(
        completionHandler: @escaping (Result<User, Error>) -> Void
    ) {
        let apiPath = "/api/v1/user"
        guard let request = Authentication.shared.constructURLRequest(withPath: apiPath) else {
            completionHandler(Result.failure(NetworkingError.requestConstructError(apiPath)))
            return
        }

        let task = URLSession.jsonRequest(forResponseType: User.self, withRequest: request, withMethod: .get, completionHandler: completionHandler)
        task.resume()
    }
}
