//
//  BasicGraphQLToSwiftTranspiler.swift
//  
//
//  Created by Mathias Quintero on 12/18/19.
//

import Foundation
import SwiftSyntax

struct BasicGraphQLToSwiftTranspiler: GraphQLToSwiftTranspiler {

    func expression(from value: GraphQLValue,
                    for type: Schema.GraphQLType.Field.TypeReference,
                    using api: API) throws -> ExprSyntax {

        switch (value, type) {

        case (.array(let array), .complex(let definition, let type)):
            guard definition.kind == .list else { break }
            let expressions = try array
                .map { try expression(from: $0, for: type, using: api) } as [ExprSyntax]

            return ArrayExprSyntax(expressions: expressions)

        case (.dictionary(let dictionary), .concrete(let definition)):
            guard definition.kind == .inputObject, let name = definition.name else { break }
            let type = api[name]?.graphQLType ?! fatalError()
            let expressions: [(String, ExprSyntax)] = try type
                .inputFields?
                .map { field in
                    let value = dictionary[field.name] ?? field.defaultValue ?! fatalError()
                    return (field.name, try expression(from: value, for: field.type, using: api))
                } ?? []

            return FunctionCallExprSyntax(target: MemberAccessExprSyntax(base: IdentifierExprSyntax(identifier: api.name),
                                                                         name: name),
                                          arguments: expressions)

        case (.identifier(let identifier), .concrete(let type)):
            guard type.kind == .enum, let name = type.name else { break }
            return MemberAccessExprSyntax(base: MemberAccessExprSyntax(base: IdentifierExprSyntax(identifier: api.name),
                                                                       name: name),
                                          name: identifier.camelized)

        case (.int(let int), .concrete(let type)):
            guard type.kind == .scalar else { break }
            let literal = SyntaxFactory.makeIntegerLiteral(String(int))
            return SyntaxFactory.makeIntegerLiteralExpr(digits: literal)

        case (.double(let double), .concrete(let type)):
            guard type.kind == .scalar else { break }
            let literal = SyntaxFactory.makeFloatingLiteral(String(double))
            return SyntaxFactory.makeFloatLiteralExpr(floatingDigits: literal)

        case (.string(let string), .concrete(let type)):
            guard type.kind == .scalar else { break }
            return SyntaxFactory.makeStringLiteralExpr(string)

        case (.bool(let bool), .concrete(let type)):
            guard type.kind == .scalar else { break }
            let literal = bool ? SyntaxFactory.makeTrueKeyword() : SyntaxFactory.makeFalseKeyword()
            return SyntaxFactory.makeBooleanLiteralExpr(booleanLiteral: literal)

        case (.null, .concrete):
            let literal = SyntaxFactory.makeNilKeyword()
            return SyntaxFactory.makeNilLiteralExpr(nilKeyword: literal)

        case (.null, .complex(let definition, _)):
            if definition.kind == .nonNull {
                fatalError()
            } else {
                let literal = SyntaxFactory.makeNilKeyword()
                return SyntaxFactory.makeNilLiteralExpr(nilKeyword: literal)
            }

        case (_, .complex(let definition, let type)):
            if definition.kind == .nonNull {
                return try expression(from: value, for: type, using: api)
            }

        default:
            break

        }

        fatalError()
    }

}
