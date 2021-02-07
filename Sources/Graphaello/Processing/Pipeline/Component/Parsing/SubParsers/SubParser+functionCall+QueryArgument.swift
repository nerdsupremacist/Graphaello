import Foundation
import SwiftSyntax

extension SubParser {
    
    static func functionCall() -> SubParser<FunctionCallExprSyntax, Argument.QueryArgument> {
        return .init { expression in
            if let calledMember = expression.calledExpression.as(MemberAccessExprSyntax.self),
                calledMember.name.text == "withDefault" {

                guard let argument = Array(expression.argumentList).single() else {
                    throw ParseError.cannotInstantiateObjectFromExpression(expression.erased(),
                                                                           type: Argument.QueryArgument.self)

                }
                return .withDefault(argument.expression)
            } else {
                return .withDefault(expression.erased())
            }
        }
    }
    
}
