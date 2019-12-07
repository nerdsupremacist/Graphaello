//
//  GraphQLPath+Component+parsing.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 12/4/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SwiftSyntax

extension StandardComponent.Argument {

    init(argument: FunctionCallArgumentSyntax) throws {
        try self.init(expression: argument.expression)
    }

    private init(expression: ExprSyntax) throws {
        switch expression {
        case let expression as FunctionCallExprSyntax:
            try self.init(expression: expression)
        case let expression as MemberAccessExprSyntax:
            try self.init(expression: expression)
        default:
            throw ParseError.cannotInstantiateObjectFromExpression(expression, type: StandardComponent.Argument.self)
        }
    }

    private init(expression: MemberAccessExprSyntax) throws {
        try self.init(calledMember: expression, argument: nil)
    }

    private init(expression: FunctionCallExprSyntax) throws {
        guard let calledMember = expression.calledExpression as? MemberAccessExprSyntax else {
            throw ParseError.cannotInstantiateObjectFromExpression(expression, type: StandardComponent.Argument.self)
        }
        try self.init(calledMember: calledMember, argument: Array(expression.argumentList).single())
    }
    
    private init(calledMember: MemberAccessExprSyntax, argument: FunctionCallArgumentSyntax?) throws {
        switch (calledMember.name.text, argument?.expression) {
        case ("value", .some(let expression)):
            self = .value(expression)
        case ("argument", .some(let expression)):
            self = .argument(try .init(expression: expression))
        case ("argument", .none):
            self = .argument(.forced)
        default:
            throw ParseError.cannotInstantiateObjectFromExpression(calledMember, type: StandardComponent.Argument.self)
        }
    }

}
