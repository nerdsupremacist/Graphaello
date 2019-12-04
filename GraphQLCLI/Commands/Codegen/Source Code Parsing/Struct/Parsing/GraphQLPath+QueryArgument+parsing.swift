//
//  GraphQLPath+QueryArgument+parsing.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 12/4/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SwiftSyntax

extension GraphQLPath.Component.Argument.QueryArgument {

    // TODO: check that we're using the correct expression based on base of member access/argument names
    init(expression: ExprSyntax) throws {
        switch expression {
        case let expression as MemberAccessExprSyntax:
            try self.init(expression: expression)
        case let expression as FunctionCallExprSyntax:
            try self.init(expression: expression)
        default:
            self = .withDefault(expression)
        }
    }

    private init(expression: MemberAccessExprSyntax) throws {
        if expression.name.text == "forced" {
            self = .forced
        } else {
            self = .withDefault(expression)
        }
    }

    private init(expression: FunctionCallExprSyntax) throws {
        if let calledMember = expression.calledExpression as? MemberAccessExprSyntax,
            calledMember.name.text == "withDefault" {

            guard let argument = Array(expression.argumentList).single() else { fatalError() }
            self = .withDefault(argument.expression)
        } else {
            self = .withDefault(expression)
        }
    }

}
