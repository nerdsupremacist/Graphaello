//
//  PathFromAnnotationFunctionCallParser.swift
//  Graphaello
//
//  Created by Mathias Quintero on 12/8/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SwiftSyntax

struct PathFromAnnotationFunctionCallParser<Parser: SubParser>: SubParser where Parser.Input == ExprSyntax, Parser.Output == Stage.Parsed.Path {
    let parser: Parser

    func parse(from call: FunctionCallExprSyntax) throws -> Stage.Parsed.Path? {
        guard let calledExpression = call.calledExpression as? IdentifierExprSyntax,
            calledExpression.identifier.text == "GraphQL",
            let expression = Array(call.argumentList).single()?.expression else { return nil }

        return try parser.parse(from: expression)
    }

}
