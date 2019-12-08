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
            guard let calledExpression = call.calledExpression as? IdentifierExprSyntax,
                calledExpression.identifier.text == "GraphQL",
                let expression = Array(call.argumentList).single()?.expression else { return nil }
            
            return try parser().parse(from: expression)
        }
    }
    
}
