//
//  StructuredFile.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 12/1/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SourceKittenFramework

struct StructuredFile {
    let code: SourceCode

    init(file: File) throws {
        code = try SourceCode(file: file)
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

extension StructuredFile {

    func structs() throws -> [Struct<Stage.Extracted>] {
        return try code.structs().map { try Struct(code: $0) }
    }

}
