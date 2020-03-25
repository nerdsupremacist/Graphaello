//
//  StructResolution+FragmentName+init.swift
//  Graphaello
//
//  Created by Mathias Quintero on 08.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SwiftSyntax

extension StructResolution.FragmentName {
    
    init(syntax: Syntax) throws {
        switch syntax.as(SyntaxEnum.self) {
        case .identifierExpr(let expression):
            self = .fullName(expression.identifier.text)
        case .memberAccessExpr(let expression):
            guard let base = expression.base else { throw GraphQLFragmentResolverError.invalidTypeNameForFragment(syntax.description) }
            self = .typealiasOnStruct(base.description, expression.name.text)
        case .optionalChainingExpr(let expression):
            try self.init(syntax: expression.expression.erased())
        case .arrayExpr(let expression):
            guard let syntax = Array(expression.elements).single()?.expression else { throw GraphQLFragmentResolverError.invalidTypeNameForFragment(expression.description) }
            try self.init(syntax: syntax.erased())
        case .arrayType(let expression):
            try self.init(syntax: expression.elementType.erased())
        case .optionalType(let expression):
            try self.init(syntax: expression.wrappedType.erased())
        case .memberTypeIdentifier(let expression):
            self = .typealiasOnStruct(expression.baseType.description, expression.name.text)
        default:
            throw GraphQLFragmentResolverError.invalidTypeNameForFragment(syntax.description)
        }
    }
    
}
