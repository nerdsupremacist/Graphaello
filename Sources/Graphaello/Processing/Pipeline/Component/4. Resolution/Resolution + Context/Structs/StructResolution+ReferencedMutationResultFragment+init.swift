//
//  File.swift
//  
//
//  Created by Mathias Quintero on 12.01.20.
//

import Foundation
import SwiftSyntax

extension StructResolution.ReferencedMutationResultFragment {
    
    init(typeName: String) throws {
        try self.init(syntax: try SourceCode(content: typeName).syntaxTree().singleItem() ?! GraphQLFragmentResolverError.invalidTypeNameForFragment(typeName))
    }

    fileprivate init(syntax: SyntaxProtocol) throws {
        try self.init(expression: try syntax as? SpecializeExprSyntax ?! GraphQLFragmentResolverError.invalidTypeNameForFragment(syntax.description))
    }
    
    fileprivate init(expression: SpecializeExprSyntax) throws {
        let argument = try Array(expression.genericArgumentClause.arguments).single() ?! GraphQLFragmentResolverError.invalidTypeNameForFragment(expression.description)
        self.init(mutationName: expression.expression.description,
                  fragmentName: try StructResolution.FragmentName(syntax: argument.argumentType))
    }
    
}
