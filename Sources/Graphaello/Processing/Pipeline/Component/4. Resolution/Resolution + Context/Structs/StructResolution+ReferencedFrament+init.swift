//
//  File 2.swift
//  
//
//  Created by Mathias Quintero on 12/20/19.
//

import Foundation
import SwiftSyntax

extension StructResolution.ReferencedFragment {

    init(typeName: String) throws {
        guard let syntax = try SourceCode(content: typeName).syntaxTree().singleItem() else  {
            throw GraphQLFragmentResolverError.invalidTypeNameForFragment(typeName)
        }
        try self.init(syntax: syntax)
    }

    fileprivate init(syntax: SyntaxProtocol) throws {
        switch syntax {

        case let expression as OptionalChainingExprSyntax:
            try self.init(syntax: expression.expression)

        case let expression as SpecializeExprSyntax:
            guard expression.expression.description == "Paging",
                let argument = Array(expression.genericArgumentClause.arguments).single() else {
                
                throw GraphQLFragmentResolverError.invalidTypeNameForFragment(syntax.description)
            }

            self = .paging(with: try StructResolution.FragmentName(syntax: argument.argumentType))

        default:
            self = .name(try StructResolution.FragmentName(syntax: syntax))

        }
    }

}
