//
// CreateLabelOption.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation

/** CreateLabelOption options for creating a label */
public struct CreateLabelOption: Codable {


    public var color: String

    public var name: String
    public init(color: String, name: String) { 
        self.color = color
        self.name = name
    }

}
