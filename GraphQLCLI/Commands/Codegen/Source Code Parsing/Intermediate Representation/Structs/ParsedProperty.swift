//
//  ParsedProperty.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 12/4/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

struct ParsedProperty {
    let code: SourceCode
    let name: String
    let type: String
    let attributes: [ParsedAttribute]

    init(code: SourceCode) throws {
        self.code = code
        name = try code.name()
        type = try code.typeName()
        attributes = try code
            .optional { try $0.attributes() }?
            .map { try ParsedAttribute(code: $0) } ?? []
    }
}
