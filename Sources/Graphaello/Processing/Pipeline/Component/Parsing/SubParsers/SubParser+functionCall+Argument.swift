import Foundation
import SwiftSyntax

extension SubParser {
    
    static func functionCall(parser: @escaping () -> SubParser<ExprSyntax, Argument.QueryArgument>) -> SubParser<FunctionCallExprSyntax, Argument> {
        return .init { expression in
            guard let calledMember = expression.calledExpression.as(MemberAccessExprSyntax.self) else {
                throw ParseError.cannotInstantiateObjectFromExpression(expression.erased(), type: Argument.self)
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
                throw ParseError.cannotInstantiateObjectFromExpression(calledMember.erased(), type: Argument.self)
            }
        }
    }
    
}
