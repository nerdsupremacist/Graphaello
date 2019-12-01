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

extension StructuredFile {

    func structs() throws -> [ParsedStruct] {
        return try code.substructure()
            .filter { try $0.kind() == .struct }
            .map { try ParsedStruct(code: $0) }
    }

}
