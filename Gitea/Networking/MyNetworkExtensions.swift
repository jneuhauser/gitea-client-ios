//
//  MyNetworkExtensions.swift
//  Gitea
//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

extension URLSession {
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }

    enum HTTPError: Error {
        case transportError(Error)
        case serverSideError(Int)
        case jsonDecodeError(String)
        case jsonEncodeError(String)
    }

    static func jsonRequest<Request: Encodable, Response: Decodable>(
        forResponseType type: Response.Type,
        withRequest request: URLRequest,
        withMethod method: HTTPMethod,
        withBody body: Request,
        completionHandler handler: @escaping (Result<Response, Error>) -> Void
    ) -> URLSessionDataTask {
        // Make non mutable function param mutable
        var request = request

        if let jsonData = body.toJsonData() {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData

            // Pretty debug output of body json object
//            if let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) {
//                debugPrint("jsonRequest(...) Request: ->")
//                debugPrint(json)
//            }
        }

        return jsonRequest(forResponseType: type, withRequest: request, withMethod: method, completionHandler: handler)
    }

    static func jsonRequest<Response: Decodable>(
        forResponseType _: Response.Type,
        withRequest request: URLRequest,
        withMethod method: HTTPMethod,
        completionHandler handler: @escaping (Result<Response, Error>) -> Void
    ) -> URLSessionDataTask {
        // Debug output of used URL
//        if let url = request.url {
//            debugPrint("jsonRequest() with URL: \(url)")
//        }

        // Make non mutable function param mutable
        var request = request

        // Set required params
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "accept")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                handler(Result.failure(HTTPError.transportError(error)))
                return
            }

            let response = response as! HTTPURLResponse
            let status = response.statusCode
            guard (200 ... 299).contains(status) else {
                handler(Result.failure(HTTPError.serverSideError(status)))
                return
            }

            // Pretty debug output of received json object
//            if let json = try? JSONSerialization.jsonObject(with: data!, options: []) {
//                debugPrint("jsonRequest(...) Response: ->")
//                debugPrint(json)
//            }

            // guard let decodedResponse = try? JSONDecoder().decode(Response.self, from: data!) else {
            guard let decodedResponse = Response.fromJson(withData: data!) else {
                handler(Result.failure(HTTPError.jsonDecodeError("\(Response.self)")))
                return
            }
            handler(Result.success(decodedResponse))
        }

        return task
    }
}

extension Encodable {
    func toJsonData() -> Data? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(rfc3339DateFormatter)
        return try? encoder.encode(self)
    }
}

extension Decodable {
    static func fromJson(withData data: Data) -> Self? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(rfc3339DateFormatter)
        return try? decoder.decode(Self.self, from: data)
    }
}
