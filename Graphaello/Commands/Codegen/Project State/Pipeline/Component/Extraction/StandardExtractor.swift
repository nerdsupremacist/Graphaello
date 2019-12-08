//
//  StandardExtractor.swift
//  Graphaello
//
//  Created by Mathias Quintero on 12/8/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SourceKittenFramework

enum StandardExtractor: Extractor {

    static func extract(from file: File) throws -> [Struct<Stage.Extracted>] {
        let code = try SourceCode(file: file)
        let structs = try code.structs()
        return []
    }

}

extension SourceCode {

    fileprivate func structs() throws -> [SourceCode] {
        let kind = try optional { try $0.kind() }
        let substructure = try optional { try $0.substructure() } ?? []
        if kind == .struct {
            return try substructure.flatMap { try $0.structs() } + [self]
        } else {
            return try substructure.flatMap { try $0.structs() }
        }
    }

}

extension SourceCode {

    fileprivate func extractStruct() throws -> Struct<Stage.Extracted> {
        let properties = try substructure()
            .filter { try $0.kind() == .varInstance }
            .map { try Property(code: $0) }

        return Struct(code: self,
                      name: try name(),
                      properties: properties)
    }

}

extension SourceCode {

    fileprivate func extractProperty() throws -> Property<Stage.Extracted> {
        let attributes = try optional { try $0.attributes() }?
            .map { code in
                try code.extractAttribute()
            } ?? []

        return Property(code: self,
                        name: try name(),
                        type: try typeName(),
                        info: attributes)
    }

}

extension SourceCode {

    fileprivate func extractAttribute() throws -> Stage.Extracted.Attribute {
        return Stage.Extracted.Attribute(code: self, kind: try attribute())
    }

}
