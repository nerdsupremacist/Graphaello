//
//  QueryArgumentFromFunctionCallParser.swift
//  Graphaello
//
//  Created by Mathias Quintero on 12/8/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SwiftSyntax

struct QueryArgumentFromFunctionCallParser: SubParser {

    func parse(from expression: FunctionCallExprSyntax) throws -> Argument.QueryArgument {
        if let calledMember = expression.calledExpression as? MemberAccessExprSyntax,
            calledMember.name.text == "withDefault" {

            guard let argument = Array(expression.argumentList).single() else {
                throw ParseError.cannotInstantiateObjectFromExpression(expression,
                                                                       type: Argument.QueryArgument.self)

            }
            return .withDefault(argument.expression)
        } else {
            return .withDefault(expression)
        }
    }

}
