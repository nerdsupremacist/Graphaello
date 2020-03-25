//
//  PathFromAnnotationFunctionCallParser.swift
//  Graphaello
//
//  Created by Mathias Quintero on 12/8/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SwiftSyntax

extension SubParser {
    
    static func annotationFunctionCall(parser: @escaping () -> SubParser<ExprSyntax, Stage.Parsed.Path>) -> SubParser<FunctionCallExprSyntax, Stage.Parsed.Path?> {
        return .init { call in
            switch call.calledExpression.switchOver() {
            case .identifierExpr(let calledExpression) where calledExpression.identifier.text == "GraphQL":
                break
            case .specializeExpr(let calledExpression):
                guard let identifier = calledExpression.expression.as(IdentifierExprSyntax.self),
                    identifier.identifier.text == "GraphQL" else { return nil }
                
                break
            default:
                return nil
            }
            
            guard let expression = Array(call.argumentList).single()?.expression else { return nil }

            return try parser().parse(from: expression)
        }
    }
    
}
