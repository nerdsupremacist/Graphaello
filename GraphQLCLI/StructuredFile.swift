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
        code = SourceCode(file: file,
                          dictionary: try Structure(file: file).dictionary)
    }
}

extension SourceCode {

    fileprivate func structs() -> [SourceCode] {
        let kind = try? self.kind()
        let substructure = (try? self.substructure()) ?? []
        if kind == .struct {
            return [self] + substructure.flatMap { $0.structs() }
        } else {
            return substructure.flatMap { $0.structs() }
        }
    }

}

extension StructuredFile {

    func structs() throws -> [ParsedStruct] {
        return try code.structs().map { try ParsedStruct(code: $0) }
    }

}
