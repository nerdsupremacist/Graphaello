//
//  ArgumentFromFunctionCallParser.swift
//  Graphaello
//
//  Created by Mathias Quintero on 12/8/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SwiftSyntax

struct ArgumentFromFunctionCallParser<Parser: SubParser>: SubParser where Parser.Input == ExprSyntax, Parser.Output == Argument.QueryArgument {
    let parser: Parser

    func parse(from expression: FunctionCallExprSyntax) throws -> Argument {
        guard let calledMember = expression.calledExpression as? MemberAccessExprSyntax else {
            throw ParseError.cannotInstantiateObjectFromExpression(expression, type: Argument.self)
        }

        let argument = Array(expression.argumentList).single()?.expression

        switch (calledMember.name.text, argument) {
        case ("value", .some(let expression)):
            return .value(expression)
        case ("argument", .some(let expression)):
            return .argument(try parser.parse(from: expression))
        case ("argument", .none):
            return .argument(.forced)
        default:
            throw ParseError.cannotInstantiateObjectFromExpression(calledMember, type: Argument.self)
        }
    }
}
