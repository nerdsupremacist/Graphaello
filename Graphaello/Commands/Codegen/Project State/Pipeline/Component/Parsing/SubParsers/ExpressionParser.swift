//
//  ExpressionParser.swift
//  Graphaello
//
//  Created by Mathias Quintero on 12/8/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SwiftSyntax

struct ExpressionParser<MethodAccessParser: SubParser, FunctionCallParser: SubParser>: SubParser where MethodAccessParser.Input == MemberAccessExprSyntax, FunctionCallParser.Input == FunctionCallExprSyntax, MethodAccessParser.Output == FunctionCallParser.Output {

    let methodAccessParser: (AnyParser<Input, Output>) -> MethodAccessParser
    let functionCallParser: (AnyParser<Input, Output>) -> FunctionCallParser

    func parse(from expression: ExprSyntax) throws -> MethodAccessParser.Output {
        switch expression {
        case let expression as MemberAccessExprSyntax:
            return try methodAccessParser(eraseType()).parse(from: expression)
        case let expression as FunctionCallExprSyntax:
            return try functionCallParser(eraseType()).parse(from: expression)
        default:
            throw ParseError.cannotInstantiateObjectFromExpression(expression, type: Output.self)
        }
    }
}
