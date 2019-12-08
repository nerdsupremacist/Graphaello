//
//  ExpressionParser.swift
//  Graphaello
//
//  Created by Mathias Quintero on 12/8/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SwiftSyntax

extension SubParser {
    
    static func expressionWithParent(memberAccess: @escaping (SubParser<ExprSyntax, Output>) -> SubParser<MemberAccessExprSyntax, Output>,
                                     functionCall: @escaping (SubParser<ExprSyntax, Output>) -> SubParser<FunctionCallExprSyntax, Output>) -> SubParser<ExprSyntax, Output> {
        
        return SubParser.expression(memberAccess: memberAccess,
                           functionCall: functionCall) { expression in
        
            return .failure(ParseError.cannotInstantiateObjectFromExpression(expression, type: Output.self))
        }
    }
    
    static func expression(memberAccess: @escaping () -> SubParser<MemberAccessExprSyntax, Output>,
                           functionCall: @escaping () -> SubParser<FunctionCallExprSyntax, Output>) -> SubParser<ExprSyntax, Output> {
        
        return .expressionWithParent(memberAccess: { _ in memberAccess() }, functionCall: { _ in functionCall() })
    }
    
}

extension SubParser {
    
    private static func expression(memberAccess: @escaping (SubParser<ExprSyntax, Output>) -> SubParser<MemberAccessExprSyntax, Output>,
                                   functionCall: @escaping (SubParser<ExprSyntax, Output>) -> SubParser<FunctionCallExprSyntax, Output>,
                                   default defaultCase: @escaping (ExprSyntax) -> Result<Output, Error>) -> SubParser<ExprSyntax, Output> {
        
        return .init { expression, parser in
            switch expression {
            case let expression as MemberAccessExprSyntax:
                return try memberAccess(parser).parse(from: expression)
            case let expression as FunctionCallExprSyntax:
                return try functionCall(parser).parse(from: expression)
            default:
                return try defaultCase(expression).get()
            }
        }
    }
    
}
