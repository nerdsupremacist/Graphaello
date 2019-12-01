//
//  ParsedStruct.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 12/1/19.
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

struct ParsedProperty {
    let code: SourceCode
    let name: String
    let type: String
    let attributes: [ParsedAttribute]

    init(code: SourceCode) throws {
        self.code = code
        name = try code.name()
        type = try code.typeName()
        attributes = try (try? code.attributes())?.map { try ParsedAttribute(code: $0) } ?? []
    }
}

struct ParsedStruct {
    let code: SourceCode
    let name: String
    let properties: [ParsedProperty]

    init(code: SourceCode) throws {
        self.code = code
        name = try code.name()
        properties = try code
            .substructure()
            .filter { (try? $0.kind()) == .some(.varInstance) }
            .map { try ParsedProperty(code: $0) }
    }
}
