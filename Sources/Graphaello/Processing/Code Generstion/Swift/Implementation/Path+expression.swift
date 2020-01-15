//
//  Path+expression.swift
//  
//
//  Created by Mathias Quintero on 12/21/19.
//

import Foundation

extension Stage.Cleaned.Path {

    func expression(queryValueIsOptional: Bool = false) -> String {
        let first: AttributePath

        switch resolved.validated.parsed.target {
        case .query, .mutation:
            first = AttributePath(name: "data", kind: queryValueIsOptional ? .optional(.value) : .value)
        case .object(let type):
            first = AttributePath(name: type.camelized, kind: .value)
        }

        return components
            .reduce(.attributePath([first], on: nil)) { $0 + $1.path(referencedFragment: resolved.referencedFragment?.fragment) }
            .expression()
    }

}

indirect private enum Expression {
    case operation(Operation, on: Expression)
    case attributePath([AttributePath], on: Expression?)
}

extension Expression {

    var kind: AttributePath.Kind {
        switch self {
        case .attributePath(let path, _):
            return path.last?.kind ?? .value
        case .operation(.compactMap, let expression):
            switch expression.kind {
            case .array(.optional(let kind)):
                return .array(kind)
            case .optional(.array(.optional(let kind))):
                return .optional(.array(kind))
            default:
                fatalError()
            }
        case .operation(.flatten, let expression):
            switch expression.kind {
            case .array(.array(let kind)):
                return .array(kind)
            case .optional(.array(.array(let kind))):
                return .optional(.array(kind))
            default:
                fatalError()
            }
        case .operation(.nonNull, let expression), .operation(.withDefault, let expression):
            guard case .optional(let kind) = expression.kind else { fatalError() }
            return kind
        }
    }

}

private enum PartialExpression {
    case operation(Operation)
    case path([AttributePath])
    case none
}

private struct AttributePath {
    indirect enum Kind {
        case value
        case array(Kind)
        case optional(Kind)
    }

    let name: String
    let kind: Kind
}

extension Expression {

    fileprivate static func + (lhs: Expression, rhs: PartialExpression) -> Expression {
        switch (lhs, rhs) {
        case (_, .operation(let operation)):
            return .operation(operation, on: lhs)
        case (.operation, .path(let path)):
            return .attributePath(path, on: lhs)
        case (.attributePath(let lhs, let expression), .path(let rhs)):
            return .attributePath(lhs + rhs, on: expression)
        case (_, .none):
            return lhs
        }
    }

}

extension Expression {

    func expression() -> String {
        switch self {
        case .operation(.compactMap, let expression):
            return "(\(expression.expression())).compactMap { $0 }"
        case .operation(.flatten, let expression):
            return "(\(expression.expression())).flatMap { $0 }"
        case .operation(.withDefault(let defaultValue), let expression):
            return "\(expression.expression()) ?? \(defaultValue.description)"
        case .operation(.nonNull, let expression):
            return "\(expression.expression())!"
        case (.attributePath(let path, .none)):
            return path.expression()
        case (.attributePath(let path, .some(let expression))):
            let expression = AttributePath(name: "(\(expression.expression()))", kind: expression.kind)
            return expression.expression(attributes: path)
        }
    }

}

extension AttributePath.Kind {

    init(from reference: Schema.GraphQLType.Field.TypeReference) {
        switch reference {
        case .concrete(_):
            self = .optional(.value)
        case .complex(let definition, let reference):
            switch (definition.kind, AttributePath.Kind(from: reference)) {
            case (.list, let value):
                self = .optional(.array(value))
            case (.nonNull, .optional(let value)):
                self = value
            default:
                self = .value
            }
        }
    }

}

extension Collection where Element == AttributePath {

    func expression() -> String {
        guard let first = first else { fatalError() }
        return first.expression(attributes: dropFirst())
    }

}

extension AttributePath {

    func expression<C: Collection>(attributes: C) -> String where C.Element == AttributePath {
        guard let next = attributes.first else { return name }
        switch kind {
        case .value:
            let rest = next.expression(attributes: attributes.dropFirst())
            return "\(name).\(rest)"
        case .array(let kind):
            let subExpression = AttributePath(name: "$0", kind: kind)
            let rest = subExpression.expression(attributes: attributes)
            return "\(name).map { \(rest) }"
        case .optional(let kind):
            let subExpression = AttributePath(name: "", kind: kind)
            let rest = subExpression.expression(attributes: attributes)
            return "\(name)?\(rest)"
        }
    }

}

extension Stage.Cleaned.Component {

    fileprivate func path(referencedFragment: GraphQLFragment?) -> PartialExpression {
        switch (validated.reference, validated.parsed, referencedFragment) {
        case (.casting(.down), _, _):
            return .path([
                AttributePath(name: "as\(validated.underlyingType.name)",
                              kind: .optional(.value))
            ])
        case (.casting(.up), _, _):
            return .none
        case (_, .operation(let operation), _):
            return .operation(operation)
        case (_, .property(let name), _):
            return .path([
                AttributePath(name: alias?.camelized ?? name.camelized,
                              kind: .init(from: validated.fieldType ?! fatalError()))
            ])
        case (_, .fragment, .some(let fragment)):
            return .path([
                AttributePath(name: "fragments", kind: .value),
                AttributePath(name: fragment.name.camelized, kind: .value)
            ])
        case (_, .fragment, .none):
            return .none
        case (_, .call(let name, _), _):
            return .path([
                AttributePath(name: alias?.camelized ?? name,
                              kind: .init(from: validated.fieldType ?! fatalError()))
            ])
        }
    }

}
