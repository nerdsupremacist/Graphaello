//
//  ParsedAttribute.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 12/4/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SourceKittenFramework

struct ParsedAttribute {
    let code: SourceCode
    let kind: SwiftDeclarationAttributeKind

    init(code: SourceCode) throws {
        self.code = code
        kind = try code.attribute()
    }
}
