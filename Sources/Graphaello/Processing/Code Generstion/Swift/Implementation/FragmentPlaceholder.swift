
import Foundation
import Stencil

struct QueryDataPlaceholder: Hashable {
    let api: API
    let queryName: String
    let arguments: [FragmentPlaceholder.Argument]
}

extension QueryDataPlaceholder: ExtraValuesSwiftCodeTransformable {

    func arguments(from context: Stencil.Context, arguments: [Any?]) throws -> [String : Any] {
        return ["placeholderCode" : code]
    }

}

struct FragmentPlaceholder: Hashable {
    struct Argument: Hashable {
        indirect enum Value: Hashable {
            case string
            case int
            case double
            case bool
            case enumValue(swiftType: String, value: String)
            case array(Value)
            case dictionary([Argument])
            case hardcoded(String)
        }

        let name: String
        let value: Value
    }

    let api: API
    let fragmentName: String
    let arguments: [Argument]
}

extension FragmentPlaceholder: ExtraValuesSwiftCodeTransformable {

    func arguments(from context: Stencil.Context, arguments: [Any?]) throws -> [String : Any] {
        return ["placeholderCode" : code]
    }

}

extension QueryDataPlaceholder {

    var code: String {
        return FragmentPlaceholder.Argument.Value.dictionary(arguments).code
    }

}

extension FragmentPlaceholder {

    var code: String {
        return Argument.Value.dictionary(arguments).code
    }

}

extension FragmentPlaceholder.Argument.Value {

    var type: String {
        switch self {
        case .string:
            return "String"
        case .int:
            return "Int"
        case .double:
            return "Double"
        case .bool:
            return "Bool"
        case .enumValue(let type, _):
            return type
        case .dictionary:
            return "ResultMap"
        case .array(let type):
            return "[\(type.type)]"
        case .hardcoded:
            return "Any"
        }
    }

    var code: String {
        switch self {
        case .string:
            return "\"__GRAPHAELLO_PLACEHOLDER__\""
        case .int:
            return "42"
        case .double:
            return "42.0"
        case .bool:
            return "true"
        case .enumValue(let type, let value):
            return "\(type)(rawValue: \"\(value)\")!"
        case .dictionary(let arguments):
            let inside = arguments.map { "\"\($0.name)\" : \($0.value.code)" }.joined(separator: ",")
            return "[\(inside)]"
        case .array(let value):
            return "Array(repeating: (\(value.code)), count: 5) as \(self.type)"
        case .hardcoded(let code):
            return code
        }
    }

}

extension Struct where CurrentStage: ResolvedStage {

    var queryDataPlaceholders: OrderedSet<QueryDataPlaceholder> {
        return query.map { query -> OrderedSet<QueryDataPlaceholder> in
            let arguments = query.components.map { entry -> FragmentPlaceholder.Argument in
                let (field, component) = entry
                return FragmentPlaceholder.Argument(name: field.alias ?? field.field.name,
                                                    value: field.field.definition.type.placeholder(with: component, in: query.api))
            }
            .merge()
            return [QueryDataPlaceholder(api: query.api, queryName: query.name, arguments: arguments)]
        } ?? []
    }

    var fragmentPlaceholders: OrderedSet<FragmentPlaceholder> {
        return fragments.map(\.placeholder)
    }

}

extension GraphQLFragment {

    var placeholder: FragmentPlaceholder {
        return FragmentPlaceholder(api: api, fragmentName: name, arguments: object.placeHolderArguments(typeName: target.name, in: api))
    }

}

extension FragmentPlaceholder.Argument.Value {

    fileprivate func merge(with other: FragmentPlaceholder.Argument.Value) -> FragmentPlaceholder.Argument.Value {
        if self == other {
            return self
        }

        if case .dictionary(let oldArguments) = self, case .dictionary(let newArguments) = other {
            return .dictionary((oldArguments + newArguments).merge())
        }

        if case .array(let oldType) = self, case .array(let newType) = other {
            return .array(oldType.merge(with: newType))
        }

        fatalError("Conflicting argument types")
    }

}

extension Sequence where Element == FragmentPlaceholder.Argument {

    fileprivate func merge() -> [FragmentPlaceholder.Argument] {
        let arguments = Dictionary(map { ($0.name, $0.value) }) { $0.merge(with: $1) }

        return arguments
            .map { FragmentPlaceholder.Argument(name: $0.key, value: $0.value) }
            .sorted { $0.name < $1.name }
    }


}

extension GraphQLObject {

    func placeHolderArguments(typeName: String, in api: API) -> [FragmentPlaceholder.Argument] {
        let fromFragments = self.fragments.flatMap { $0.object.placeHolderArguments(typeName: typeName, in: api) }
        let fromValues = self.components.map { entry -> FragmentPlaceholder.Argument in
            let (field, component) = entry
            return FragmentPlaceholder.Argument(name: field.alias ?? field.field.name,
                                                value: field.field.definition.type.placeholder(with: component, in: api))
        }
        let typeNameSet = [FragmentPlaceholder.Argument(name: "__typename", value: .hardcoded("\"\(typeName)\""))]

        return (typeNameSet + fromFragments + fromValues).merge()
    }

}



extension Schema.GraphQLType.Field.TypeReference {

    fileprivate func placeholder(with component: GraphQLComponent, in api: API) -> FragmentPlaceholder.Argument.Value {
        switch self {
        case .complex(let definition, let type):
            switch definition.kind {
            case .list:
                return .array(type.placeholder(with: component, in: api))
            default:
                return type.placeholder(with: component, in: api)
            }
        case .concrete(let definition):
            if case .object = definition.kind, case .object(let object) = component, let typeName = definition.name {
                return .dictionary(object.placeHolderArguments(typeName: typeName, in: api))
            }

            if case .enum = definition.kind, let firstCase = api[definition.name!]?.graphQLType.enumValues?.first?.name {
                return .enumValue(swiftType: "\(api.name).\(definition.name!.upperCamelized)", value: firstCase)
            }

            switch definition.name {
            case "Float":
                return .double
            case "Int":
                return .int
            case "Boolean":
                return .bool
            default:
                return .string
            }
        }
    }

}
