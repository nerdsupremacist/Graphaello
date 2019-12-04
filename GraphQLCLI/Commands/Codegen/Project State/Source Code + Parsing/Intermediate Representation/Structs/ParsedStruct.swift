//
//  ParsedStruct.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 12/1/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

struct ParsedStruct {
    let code: SourceCode
    let name: String
    let properties: [ParsedProperty]

    init(code: SourceCode) throws {
        self.code = code
        name = try code.name()
        // TODO: Filter out computed properties somehow
        properties = try code
            .substructure()
            .filter { try $0.kind() == .varInstance }
            .map { try ParsedProperty(code: $0) }
    }
}
