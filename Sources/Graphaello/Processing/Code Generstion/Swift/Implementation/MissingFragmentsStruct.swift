import Foundation

struct MissingFragmentsStruct: SwiftCodeTransformable, Hashable {
    let api: API
    let path: [String]
}

extension Struct where CurrentStage: ResolvedStage {

    var missingFragmentsStructs: OrderedSet<MissingFragmentsStruct> {
        let fromQuery = query?.missingFragmentsStructs ?? []
        let fromFragments = fragments.flatMap { $0.name.upperCamelized + $0.object.missingFragmentsStructs(api: $0.api) }
        let fromConnectionQueries = connectionQueries.flatMap { $0.query.missingFragmentsStructs }
        return fromQuery + fromFragments + fromConnectionQueries
    }

}

extension GraphQLFragment {

    var missingFragmentsStructs: OrderedSet<MissingFragmentsStruct> {
        return target.name.upperCamelized + object.missingFragmentsStructs(api: api)
    }

}

extension GraphQLConnectionFragment {

    var missingFragmentsStructs: OrderedSet<MissingFragmentsStruct> {
        return fragment.name.upperCamelized + fragment.object.missingFragmentsStructs(api: fragment.api)
    }

}

extension GraphQLQuery {

    var missingFragmentsStructs: OrderedSet<MissingFragmentsStruct> {
        return ["\(name)Query".upperCamelized, "Data"] + components
            .sorted { $0.key.field.name < $1.key.field.name }
            .flatMap { $0.value.missingFragmentsStructs(field: $0.key, api: api) }
    }

}

extension GraphQLObject {

    func missingFragmentsStructs(api: API) -> OrderedSet<MissingFragmentsStruct> {
        let fromComponents = components
            .sorted { $0.key.field.name < $1.key.field.name }
            .flatMap { $0.value.missingFragmentsStructs(field: $0.key, api: api) }

        let fromTypeConditionals = typeConditionals
            .sorted { $0.key < $1.key }
            .flatMap {  $0.value.missingFragmentsStructs(api: api) }

        if referencedFragments.isEmpty {
            return fromComponents + fromTypeConditionals
        }

        if referencedFragments.contains(where: { !$0.hasArguments }) {
            return fromComponents + fromTypeConditionals
        }

        return [MissingFragmentsStruct(api: api, path: [])] + fromComponents + fromTypeConditionals
    }

}

extension GraphQLTypeConditional {

    func missingFragmentsStructs(api: API) -> OrderedSet<MissingFragmentsStruct> {
        let name = "As \(type.name)"
        return name.singular.upperCamelized + object.missingFragmentsStructs(api: api)
    }

}

extension GraphQLComponent {

    func missingFragmentsStructs(field: GraphQLField, api: API) -> OrderedSet<MissingFragmentsStruct> {
        switch self {
        case .object(let object):
            let name = field.alias ?? field.field.definition.name
            return name.singular.upperCamelized + object.missingFragmentsStructs(api: api)
        default:
            return []
        }
    }

}

extension MissingFragmentsStruct {

    static func + (lhs: String, rhs: MissingFragmentsStruct) -> MissingFragmentsStruct {
        return [lhs] + rhs
    }

    static func + (lhs: [String], rhs: MissingFragmentsStruct) -> MissingFragmentsStruct {
        return MissingFragmentsStruct(api: rhs.api, path: lhs + rhs.path)
    }

}

func + (lhs: String, rhs: OrderedSet<MissingFragmentsStruct>) -> OrderedSet<MissingFragmentsStruct> {
    return OrderedSet(rhs.map { lhs + $0 })
}

func + (lhs: [String], rhs: OrderedSet<MissingFragmentsStruct>) -> OrderedSet<MissingFragmentsStruct> {
    return OrderedSet(rhs.map { lhs + $0 })
}

