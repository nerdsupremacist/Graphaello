//
//  PathFromFunctionCallParser.swift
//  Graphaello
//
//  Created by Mathias Quintero on 12/8/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SwiftSyntax

extension SubParser {
    
    static func functionCall(parent: SubParser<ExprSyntax, Stage.Parsed.Path>,
                             parser: @escaping () -> SubParser<FunctionCallArgumentListSyntax, [Field.Argument]>) -> SubParser<FunctionCallExprSyntax, Stage.Parsed.Path> {
        
        return .init { expression in
            guard let called = expression.calledExpression as? MemberAccessExprSyntax else {
                throw ParseError.cannotInstantiateObjectFromExpression(expression, type: Stage.Parsed.Path.self)
            }

            switch called.name.text {

            case "_forEach":
                guard let keyPathExpression = Array(expression.argumentList).single()?.expression as? KeyPathExprSyntax,
                    let base = called.base else { fatalError() }
                return try parent.parse(from: keyPathExpression.expression.asMemberAccessOf(expression: base))

            case "_compactMap":
                guard Array(expression.argumentList).isEmpty, let base = called.base else { fatalError() }
                return try parent.parse(from: base).appending(operation: .compactMap)

            case "_flatten":
                guard Array(expression.argumentList).isEmpty, let base = called.base else { fatalError() }
                return try parent.parse(from: base).appending(operation: .flatten)

            case "_nonNull":
                guard Array(expression.argumentList).isEmpty, let base = called.base else { fatalError() }
                return try parent.parse(from: base).appending(operation: .nonNull)

            case "_withDefault":
                guard let expression = Array(expression.argumentList).single()?.expression,
                    let base = called.base else { fatalError() }
                return try parent.parse(from: base).appending(operation: .withDefault(expression))

            default:
                break

            }

            let arguments = try parser().parse(from: expression.argumentList)

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
    
}

extension Stage.Parsed.Path {

    fileprivate func appending(name: String, arguments: [Field.Argument]) throws -> Self {
        return .init(apiName: apiName, target: target, components: components + [.call(name, arguments)])
    }


    fileprivate func appending(operation: Operation) throws -> Self {
        return .init(apiName: apiName, target: target, components: components + [.operation(operation)])
    }

}

extension ExprSyntax {

    fileprivate func asMemberAccessOf(expression base: ExprSyntax) -> ExprSyntax {
        switch self {
        case let expression as MemberAccessExprSyntax:
            return MemberAccessExprSyntax(base: expression.base?.asMemberAccessOf(expression: base) ?? base,
                                          name: expression.name.text)

        case let expression as IdentifierExprSyntax:
            return MemberAccessExprSyntax(base: base,
                                          name: expression.identifier.text)

        case let expression as FunctionCallExprSyntax:
            return FunctionCallExprSyntax { builder in
                builder.useCalledExpression(expression.calledExpression.asMemberAccessOf(expression: base))
                for argument in expression.argumentList {
                    builder.addArgument(argument)
                }
            }

        default:
            return self

        }
    }

}
