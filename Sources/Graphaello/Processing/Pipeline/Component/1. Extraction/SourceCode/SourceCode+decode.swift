//
//  SourceCode+decode.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 12/4/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SourceKittenFramework

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

    func accesibility() throws -> Accessibility {
        return Accessibility(rawValue: try decode(key: "key.accessibility"))
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

extension SourceCode {

    fileprivate func decode<Type: SourceKitRepresentable>(key: String) throws -> Type {
        let value = try dictionary[key] ?! ParseError.missingKey(key, in: self)
        return try value as? Type ?! ParseError.valueNotTransformable(value, to: Type.self, in: self)
    }

    fileprivate func decode<Type: SourceKitRepresentable>(key: SwiftDocKey) throws -> Type {
        return try decode(key: key.rawValue)
    }


    fileprivate func decodeArray<Type: SourceKitRepresentable>(key: String) throws -> [Type] {
        return try decode(key: key)
    }

    fileprivate func decodeArray<Type: SourceKitRepresentable>(key: SwiftDocKey) throws -> [Type] {
        return try decode(key: key)
    }
}
