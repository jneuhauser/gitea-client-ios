//
// EditReleaseOption.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation

/** EditReleaseOption options when editing a release */
public struct EditReleaseOption: Codable {


    public var body: String?

    public var draft: Bool?

    public var name: String?

    public var prerelease: Bool?

    public var tagName: String?

    public var targetCommitish: String?
    public init(body: String?, draft: Bool?, name: String?, prerelease: Bool?, tagName: String?, targetCommitish: String?) { 
        self.body = body
        self.draft = draft
        self.name = name
        self.prerelease = prerelease
        self.tagName = tagName
        self.targetCommitish = targetCommitish
    }
    public enum CodingKeys: String, CodingKey { 
        case body
        case draft
        case name
        case prerelease
        case tagName = "tag_name"
        case targetCommitish = "target_commitish"
    }

}
