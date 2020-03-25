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
    
    static func annotationFunctionCall(parser: @escaping () -> SubParser<ExprSyntaxProtocol, Stage.Parsed.Path>) -> SubParser<FunctionCallExprSyntax, Stage.Parsed.Path?> {
        return .init { call in
            switch call.calledExpression.asProtocol(ExprSyntaxProtocol.self) {
            case let calledExpression as IdentifierExprSyntax where calledExpression.identifier.text == "GraphQL":
                break
            case let calledExpression as SpecializeExprSyntax:
                guard let identifier = calledExpression.expression.asProtocol(ExprSyntaxProtocol.self) as? IdentifierExprSyntax,
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
