//
//  GraphQLPath+parsing.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 12/4/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SwiftSyntax

extension Stage.Parsed.Path {

    init?(from parsed: ParsedAttribute) throws {
        guard parsed.kind == ._custom else { return nil }
        let content = parsed.code.content

        let code = try SourceCode.singleExpression(content: String(content.dropFirst()))
        try self.init(code: code)
    }

    private init?(code: SourceCode) throws {
        guard try code.kind() == .functionCall else { return nil }
        try self.init(call: try code.syntaxTree())
    }

    private init?(call: SourceFileSyntax) throws {
        guard let functionCall = call.singleItem() as? FunctionCallExprSyntax else { return nil }
        try self.init(call: functionCall)
    }

    private init?(call: FunctionCallExprSyntax) throws {
        guard let calledExpression = call.calledExpression as? IdentifierExprSyntax,
            calledExpression.identifier.text == "GraphQL",
            let expression = Array(call.argumentList).single()?.expression else { return nil }

        try self.init(expression: expression)
    }

    private init(expression: ExprSyntax) throws {
        switch expression {
        case let expression as MemberAccessExprSyntax:
            try self.init(expression: expression)
        case let expression as FunctionCallExprSyntax:
            try self.init(expression: expression)
        default:
            throw ParseError.cannotInstantiateObjectFromExpression(expression, type: Stage.Parsed.Path.self)
        }
    }

    private init(expression: FunctionCallExprSyntax) throws {
        guard let called = expression.calledExpression as? MemberAccessExprSyntax else {
            throw ParseError.cannotInstantiateObjectFromExpression(expression, type: Stage.Parsed.Path.self)
        }

        switch called.base {
        case .some(let base as IdentifierExprSyntax):
            self = try Stage.Parsed.Path(apiName: base.identifier.text,
                                         target: .query,
                                         components: []).appending(name: called.name, arguments: expression.argumentList)
        case .some(let base):
            self = try Stage.Parsed.Path(expression: base).appending(name: called.name, arguments: expression.argumentList)
        default:
            throw ParseError.expectedBaseForCalls(expression: expression)
        }
    }

    private init(expression: MemberAccessExprSyntax) throws {
        switch expression.base {
        case .some(let base as IdentifierExprSyntax):
            self.init(base: base, name: expression.name)
        case .some(let base):
            self = try Stage.Parsed.Path(expression: base).appending(expression: expression)
        default:
            throw ParseError.expectedBaseForCalls(expression: expression)
        }
    }

    private init(base: IdentifierExprSyntax, name: TokenSyntax) {
        let name = name.text
        if (name.capitalized == name) {
            self.init(apiName: base.identifier.text,
                      target: .object(name),
                      components: [])
        } else {
            self.init(apiName: base.identifier.text, target: .query, components: [.property(name)])
        }
    }

}

extension Stage.Parsed.Path {

    private func appending(expression: MemberAccessExprSyntax) -> Self {
        return .init(apiName: apiName,
                     target: target,
                     components: components + [expression.name.text == "fragment" ? .fragment : .property(expression.name.text)])
    }

    private func appending(name: TokenSyntax, arguments: FunctionCallArgumentListSyntax) throws -> Self {
        let baseDictionary = Dictionary(uniqueKeysWithValues: arguments.map { ($0.label?.text ?! fatalError(), $0) })
        let dictionary = try baseDictionary.mapValues { try Argument(argument: $0) }
        return .init(apiName: apiName, target: target, components: components + [.call(name.text, dictionary)])
    }

}
