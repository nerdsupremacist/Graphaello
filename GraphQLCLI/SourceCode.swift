//
//  SourceCode.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 12/1/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SourceKittenFramework

struct SourceCode {
    let file: File
    let dictionary: [String : SourceKitRepresentable]
}

extension SourceCode {

    func content() throws -> String {
        let start = try offset()
        let length = try self.length()
        let substring = file.contents.bridge().substringStartingLinesWithByteRange(start: Int(start), length: Int(length))
        return try substring?
            .removingCommonLeadingWhitespaceFromLines() ?! GraphQLError.parseError(self)
    }

}

extension SourceCode {
    func annotatedDeclaration() throws -> String {
        try dictionary[SwiftDocKey.annotatedDeclaration.rawValue] as? String ?! GraphQLError.parseError(self)
    }

    func bodyLength() throws -> Int64 {
        try dictionary[SwiftDocKey.bodyLength.rawValue] as? Int64 ?! GraphQLError.parseError(self)
    }

    func bodyOffset() throws -> Int64 {
        try dictionary[SwiftDocKey.bodyOffset.rawValue] as? Int64 ?! GraphQLError.parseError(self)
    }

    func diagnosticStage() throws -> String {
        try dictionary[SwiftDocKey.diagnosticStage.rawValue] as? String ?! GraphQLError.parseError(self)
    }

    func elements() throws -> [SourceCode] {
        let array = dictionary[SwiftDocKey.elements.rawValue] as? [[String: SourceKitRepresentable]]
        return try array?.map { SourceCode(file: file, dictionary: $0) } ?! GraphQLError.parseError(self)
    }

    func fullXMLDocs() throws -> String {
        try dictionary[SwiftDocKey.fullXMLDocs.rawValue] as? String ?! GraphQLError.parseError(self)
    }

    func kind() throws -> SwiftDeclarationKind {
        try (dictionary[SwiftDocKey.kind.rawValue] as? String).flatMap(SwiftDeclarationKind.init(rawValue:))  ?! GraphQLError.parseError(self)
    }

    func length() throws -> Int64 {
        try dictionary[SwiftDocKey.length.rawValue] as? Int64 ?! GraphQLError.parseError(self)
    }

    func name() throws -> String {
        try dictionary[SwiftDocKey.name.rawValue] as? String ?! GraphQLError.parseError(self)
    }

    func nameLength() throws -> Int64 {
        try dictionary[SwiftDocKey.nameLength.rawValue] as? Int64 ?! GraphQLError.parseError(self)
    }

    func nameOffset() throws -> Int64 {
        try dictionary[SwiftDocKey.nameOffset.rawValue] as? Int64 ?! GraphQLError.parseError(self)
    }

    func offset() throws -> Int64 {
        try dictionary[SwiftDocKey.offset.rawValue] as? Int64 ?! GraphQLError.parseError(self)
    }

    func substructure() throws -> [SourceCode] {
        let array = dictionary[SwiftDocKey.substructure.rawValue] as? [[String: SourceKitRepresentable]]
        return try array?.map { SourceCode(file: file, dictionary: $0) } ?! GraphQLError.parseError(self)
    }

    func syntaxMap() throws -> NSData {
        try dictionary[SwiftDocKey.syntaxMap.rawValue] as? NSData ?! GraphQLError.parseError(self)
    }

    func typeName() throws -> String {
        try dictionary[SwiftDocKey.typeName.rawValue] as? String ?! GraphQLError.parseError(self)
    }

    func inheritedtypes() throws -> [SourceKitRepresentable] {
        try dictionary[SwiftDocKey.inheritedtypes.rawValue] as? [SourceKitRepresentable] ?! GraphQLError.parseError(self)
    }

    func attributes() throws -> [SourceCode] {
        let array = dictionary["key.attributes"] as? [[String: SourceKitRepresentable]]
        return try array?.map { SourceCode(file: file, dictionary: $0) } ?! GraphQLError.parseError(self)
    }

    func attribute() throws -> SwiftDeclarationAttributeKind {
        return try (dictionary["key.attribute"] as? String).flatMap(SwiftDeclarationAttributeKind.init(rawValue:)) ?! GraphQLError.parseError(self)
    }
}
