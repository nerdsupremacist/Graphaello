//
//  ArgumentFromFunctionCallParser.swift
//  Graphaello
//
//  Created by Mathias Quintero on 12/8/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SwiftSyntax

extension SubParser {
    
    static func functionCall(parser: @escaping () -> SubParser<ExprSyntaxProtocol, Argument.QueryArgument>) -> SubParser<FunctionCallExprSyntax, Argument> {
        return .init { expression in
            guard let calledMember = expression.calledExpression.asProtocol(ExprSyntaxProtocol.self) as? MemberAccessExprSyntax else {
                throw ParseError.cannotInstantiateObjectFromExpression(expression, type: Argument.self)
            }

            let argument = Array(expression.argumentList).single()?.expression

            switch (calledMember.name.text, argument) {
            case ("value", .some(let expression)):
                return .value(expression)
            case ("argument", .some(let expression)):
                return .argument(try parser().parse(from: expression))
            case ("argument", .none):
                return .argument(.forced)
            default:
                throw ParseError.cannotInstantiateObjectFromExpression(calledMember, type: Argument.self)
            }
        }
    }
    
}
