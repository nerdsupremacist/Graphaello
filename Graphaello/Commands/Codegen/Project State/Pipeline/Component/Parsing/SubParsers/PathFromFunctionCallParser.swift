//
//  PathFromFunctionCallParser.swift
//  Graphaello
//
//  Created by Mathias Quintero on 12/8/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SwiftSyntax

struct PathFromFunctionCallParser<Parser: SubParser>: SubParser where Parser.Input == FunctionCallArgumentListSyntax, Parser.Output == [String : Argument] {
    let parent: AnyParser<ExprSyntax, Stage.Parsed.Path>
    let parser: Parser

    func parse(from expression: FunctionCallExprSyntax) throws -> Stage.Parsed.Path {
        guard let called = expression.calledExpression as? MemberAccessExprSyntax else {
            throw ParseError.cannotInstantiateObjectFromExpression(expression, type: Stage.Parsed.Path.self)
        }

        let arguments = try parser.parse(from: expression.argumentList)

        switch called.base {
        case .some(let base as IdentifierExprSyntax):
            return try Stage.Parsed.Path(apiName: base.identifier.text,
                                         target: .query,
                                         components: []).appending(name: called.name.text, arguments: arguments)
        case .some(let base):
            return try parent.parse(from: base).appending(name: called.name.text, arguments: arguments)

        default:
            throw ParseError.expectedBaseForCalls(expression: expression)

        }
    }
}

extension Stage.Parsed.Path {

    fileprivate func appending(name: String, arguments: [String : Argument]) throws -> Self {
        return .init(apiName: apiName, target: target, components: components + [.call(name, arguments)])
    }

}
