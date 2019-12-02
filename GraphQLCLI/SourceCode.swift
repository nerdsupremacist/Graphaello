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

    var content: String {
        do {
            let start = try offset()
            let length = try self.length()
            let substring = file.contents.bridge().substringStartingLinesWithByteRange(start: Int(start), length: Int(length))
            return substring?
                .removingCommonLeadingWhitespaceFromLines() ?? file.contents
        } catch {
            return file.contents
        }
    }

}

extension SourceCode {

    func optional<T>(decode: (SourceCode) throws -> T) rethrows -> T? {
        do {
            return try decode(self)
        } catch ParseError.missingKey {
            return nil
        }
    }

}

extension SourceCode {

    func decode<Type: SourceKitRepresentable>(key: String) throws -> Type {
        let value = try dictionary[key] ?! ParseError.missingKey(key, in: self)
        return try value as? Type ?! ParseError.valueNotTransformable(value, to: Type.self, in: self)
    }

    func decode<Type: SourceKitRepresentable>(key: SwiftDocKey) throws -> Type {
        return try decode(key: key.rawValue)
    }


    func decodeArray<Type: SourceKitRepresentable>(key: String) throws -> [Type] {
        return try decode(key: key)
    }

    func decodeArray<Type: SourceKitRepresentable>(key: SwiftDocKey) throws -> [Type] {
        return try decode(key: key)
    }
}

extension SourceCode {

    func annotatedDeclaration() throws -> String {
        try decode(key: .annotatedDeclaration)
    }

    func bodyLength() throws -> Int64 {
        try decode(key: .bodyLength)
    }

    func bodyOffset() throws -> Int64 {
        try decode(key: .bodyOffset)
    }

    func diagnosticStage() throws -> String {
        try decode(key: .diagnosticStage)
    }

    func elements() throws -> [SourceCode] {
        return try decodeArray(key: .elements).map { SourceCode(file: file, dictionary: $0) }
    }

    func fullXMLDocs() throws -> String {
        try decode(key: .fullXMLDocs)
    }

    func kind() throws -> Kind {
        return Kind(rawValue: try decode(key: .kind))
    }

    func length() throws -> Int64 {
        try decode(key: .length)
    }

    func name() throws -> String {
        try decode(key: .name)
    }

    func nameLength() throws -> Int64 {
        try decode(key: .nameLength)
    }

    func nameOffset() throws -> Int64 {
        try decode(key: .nameOffset)
    }

    func offset() throws -> Int64 {
        try decode(key: .offset)
    }

    func substructure() throws -> [SourceCode] {
        return try decodeArray(key: .substructure).map { SourceCode(file: file, dictionary: $0) }
    }

    func typeName() throws -> String {
        try decode(key: .typeName)
    }

    func inheritedtypes() throws -> [SourceKitRepresentable] {
        try decode(key: .inheritedtypes)
    }

    func attributes() throws -> [SourceCode] {
        return try decodeArray(key: "key.attributes").map { SourceCode(file: file, dictionary: $0) }
    }

    func attribute() throws -> SwiftDeclarationAttributeKind {
        return SwiftDeclarationAttributeKind(rawValue: try decode(key: "key.attribute")) ?? ._custom
    }

}
