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
    
    init(syntax: SyntaxProtocol) throws {
        switch syntax {
        case let expression as IdentifierExprSyntax:
            self = .fullName(expression.identifier.text)
        case let expression as MemberAccessExprSyntax:
            guard let base = expression.base?.withoutErasure() else { throw GraphQLFragmentResolverError.invalidTypeNameForFragment(syntax.description) }
            self = .typealiasOnStruct(base.description, expression.name.text)
        case let expression as OptionalChainingExprSyntax:
            try self.init(syntax: expression.expression.withoutErasure())
        case let expression as ArrayExprSyntax:
            guard let syntax = Array(expression.elements).single()?.expression.withoutErasure() else { throw GraphQLFragmentResolverError.invalidTypeNameForFragment(expression.description) }
            try self.init(syntax: syntax)
        case let expression as ArrayTypeSyntax:
            try self.init(syntax: expression.elementType)
        case let expression as OptionalTypeSyntax:
            try self.init(syntax: expression.wrappedType)
        case let expression as MemberTypeIdentifierSyntax:
            self = .typealiasOnStruct(expression.baseType.description, expression.name.text)
        default:
            throw GraphQLFragmentResolverError.invalidTypeNameForFragment(syntax.description)
        }
    }
    
}
