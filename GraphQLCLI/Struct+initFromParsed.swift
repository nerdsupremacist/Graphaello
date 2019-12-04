//
//  Struct+initFromParsed.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 12/3/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SwiftSyntax
import SourceKittenFramework

extension GraphQLPath.Component.Argument {

    init(argument: FunctionCallArgumentSyntax) throws {
        // TODO:
        self = .argument(.forced)
    }

}

extension GraphQLPath {

    private func appending(expression: MemberAccessExprSyntax) -> GraphQLPath {
        return GraphQLPath(apiName: apiName,
                           target: target,
                           path: path + [expression.name.text == "fragment" ? .fragment : .property(expression.name.text)])
    }

    private func appending(name: TokenSyntax, arguments: FunctionCallArgumentListSyntax) throws -> GraphQLPath {
        let baseDictionary = Dictionary(uniqueKeysWithValues: arguments.map { ($0.label?.text ?! fatalError(), $0) })
        let dictionary = try baseDictionary.mapValues { try GraphQLPath.Component.Argument(argument: $0) }
        return GraphQLPath(apiName: apiName, target: target, path: path + [.call(name.text, dictionary)])
    }

}

extension GraphQLPath {

    private init(base: IdentifierExprSyntax, name: TokenSyntax) {
        let name = name.text
        if (name.capitalized == name) {
            self.init(apiName: base.identifier.text,
                      target: .object(name),
                      path: [])
        } else {
            self.init(apiName: base.identifier.text, target: .query, path: [.property(name)])
        }
    }

    private init(expression: MemberAccessExprSyntax) throws {
        switch expression.base {
        case .some(let base as IdentifierExprSyntax):
            self.init(base: base, name: expression.name)
        case .some(let base):
            self = try GraphQLPath(expression: base).appending(expression: expression)
        default:
            throw ParseError.expectedBaseForCalls(expression: expression)
        }
    }

    private init(expression: FunctionCallExprSyntax) throws {
        guard let called = expression.calledExpression as? MemberAccessExprSyntax else { fatalError() }
        switch called.base {
        case .some(let base as IdentifierExprSyntax):
            self = try GraphQLPath(apiName: base.identifier.text,
                                   target: .query,
                                   path: []).appending(name: called.name, arguments: expression.argumentList)
        case .some(let base):
            self = try GraphQLPath(expression: base).appending(name: called.name, arguments: expression.argumentList)
        default:
            throw ParseError.expectedBaseForCalls(expression: expression)
        }
    }

    private init(expression: ExprSyntax) throws {
        switch expression {
        case let expression as MemberAccessExprSyntax:
            try self.init(expression: expression)
        case let expression as FunctionCallExprSyntax:
            try self.init(expression: expression)
        default:
            throw ParseError.unexpectedExpressionInGraphQLPath(expression: expression)
        }
    }

    private init?(call: FunctionCallExprSyntax) throws {
        guard let calledExpression = call.calledExpression as? IdentifierExprSyntax,
            calledExpression.identifier.text == "GraphQL",
            let expression = Array(call.argumentList).single()?.expression else { return nil }

        try self.init(expression: expression)
    }

    private init?(call: SourceFileSyntax) throws {
        let blocks = Array(call.statements)
        guard let functionCall = blocks.single()?.item as? FunctionCallExprSyntax else { return nil }
        try self.init(call: functionCall)
    }

    private init?(code: SourceCode) throws {
        guard try code.kind() == .functionCall else { return nil }
        try self.init(call: try code.syntaxTree())
    }

    init?(from parsed: ParsedAttribute) throws {
        guard parsed.kind == ._custom else { return nil }
        let content = parsed.code.content

        let code = try SourceCode.singleExpression(content: content)
        try self.init(code: code)
    }

}

extension Property {

    init(from parsed: ParsedProperty) throws {
        self.init(code: parsed.code,
                  name: parsed.name,
                  type: parsed.type,
                  graphqlPath: try parsed.attributes.compactMap { try GraphQLPath(from: $0) }.first)
    }

}

extension Struct {

    init(from parsed: ParsedStruct) throws {
        self.init(code: parsed.code,
                  name: parsed.name,
                  properties: try parsed.properties.map { try Property(from: $0) })
    }

}
