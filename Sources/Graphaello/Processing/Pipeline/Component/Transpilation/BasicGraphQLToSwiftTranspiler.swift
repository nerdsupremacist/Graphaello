import Foundation
import SwiftSyntax
import GraphQLSyntax

struct BasicGraphQLToSwiftTranspiler: GraphQLToSwiftTranspiler {

    func expression(from value: GraphQL.Value?,
                    for type: Schema.GraphQLType.Field.TypeReference,
                    using api: API) throws -> ExprSyntaxProtocol? {

        guard let value = value else {
            if case .complex(let definition, _) = type, definition.kind == .nonNull {
                return nil
            } else {
                let literal = SyntaxFactory.makeNilKeyword()
                return SyntaxFactory.makeNilLiteralExpr(nilKeyword: literal)
            }
        }

        return try expression(from: value, for: type, using: api) as ExprSyntaxProtocol
    }

    func expression(from value: GraphQL.Value,
                    for type: Schema.GraphQLType.Field.TypeReference,
                    using api: API) throws -> ExprSyntaxProtocol {

        switch (value, type) {

        case (.array(let array), .complex(let definition, let type)) where definition.kind == .list:
            let expressions = try array
                .map { try expression(from: $0, for: type, using: api) } as [ExprSyntaxProtocol]

            return ArrayExprSyntax(expressions: expressions)

        case (.dictionary(let dictionary), .concrete(let definition)) where definition.kind == .inputObject:
            guard let name = definition.name else { break }
            let type = api[name]?.graphQLType ?! fatalError()
            let expressions: [(String, ExprSyntaxProtocol)] = try type
                .inputFields?
                .map { field in
                    let value = dictionary[field.name] ?? field.defaultValue ?! fatalError()
                    return (field.name, try expression(from: value, for: field.type, using: api))
                } ?? []

            return FunctionCallExprSyntax(target: MemberAccessExprSyntax(base: IdentifierExprSyntax(identifier: api.name),
                                                                         name: name),
                                          arguments: expressions)

        case (.identifier(let identifier), .concrete(let type)) where type.kind == .enum:
            guard let name = type.name?.upperCamelized else { break }
            return MemberAccessExprSyntax(base: MemberAccessExprSyntax(base: IdentifierExprSyntax(identifier: api.name),
                                                                       name: name),
                                          name: identifier.camelized)

        case (.int(let int), .concrete(let type)) where type.kind == .scalar:
            let literal = SyntaxFactory.makeIntegerLiteral(String(int))
            return SyntaxFactory.makeIntegerLiteralExpr(digits: literal)

        case (.double(let double), .concrete(let type)) where type.kind == .scalar:
            let literal = SyntaxFactory.makeFloatingLiteral(String(double))
            return SyntaxFactory.makeFloatLiteralExpr(floatingDigits: literal)

        case (.string(let string), .concrete(let type)) where type.kind == .scalar:
            return SyntaxFactory.makeStringLiteralExpr(string)

        case (.bool(let bool), .concrete(let type)) where type.kind == .scalar:
            let literal = bool ? SyntaxFactory.makeTrueKeyword() : SyntaxFactory.makeFalseKeyword()
            return SyntaxFactory.makeBooleanLiteralExpr(booleanLiteral: literal)

        case (.null, .concrete):
            let literal = SyntaxFactory.makeNilKeyword()
            return SyntaxFactory.makeNilLiteralExpr(nilKeyword: literal)

        case (.null, .complex(let definition, _)) where definition.kind != .nonNull:
            let literal = SyntaxFactory.makeNilKeyword()
            return SyntaxFactory.makeNilLiteralExpr(nilKeyword: literal)

        case (_, .complex(let definition, let type)) where definition.kind == .nonNull:
            return try expression(from: value, for: type, using: api)

        default:
            break

        }

        fatalError()
    }

}
