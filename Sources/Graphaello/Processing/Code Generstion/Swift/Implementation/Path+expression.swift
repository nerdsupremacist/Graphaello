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

        let path = components.flatMap { $0.path(referencedFragment: resolved.referencedFragment?.fragment) }
        return first.expression(attributes: path)
    }

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

    fileprivate func path(referencedFragment: GraphQLFragment?) -> [AttributePath] {
        switch (validated.reference, validated.parsed, referencedFragment) {
        case (.casting(.down), _, _):
            return [AttributePath(name: "as\(validated.underlyingType.name)", kind: .optional(.value))]
        case (.casting(.up), _, _):
            return []
        case (_, .property(let name), _):
            return [AttributePath(name: alias?.camelized ?? name.camelized, kind: .init(from: validated.fieldType))]
        case (_, .fragment, .some(let fragment)):
            return [AttributePath(name: "fragments", kind: .value), AttributePath(name: fragment.name.camelized, kind: .value)]
        case (_, .fragment, .none):
            return []
        case (_, .call(let name, _), _):
            return [AttributePath(name: alias?.camelized ?? name, kind: .init(from: validated.fieldType))]
        }
    }

}
