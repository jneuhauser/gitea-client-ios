//
// CommitMeta.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct CommitMeta: Codable {


    public var sha: String?

    public var url: String?
    public init(sha: String?, url: String?) { 
        self.sha = sha
        self.url = url
    }

}
