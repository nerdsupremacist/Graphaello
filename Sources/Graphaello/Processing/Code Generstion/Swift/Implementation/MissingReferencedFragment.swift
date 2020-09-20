import Foundation

struct MissingReferencedFragment: SwiftCodeTransformable, Hashable {
    let api: API
    let path: [String]
    let fragmentName: String
}

extension Struct where CurrentStage: ResolvedStage {

    var missingReferencedFragments: OrderedSet<MissingReferencedFragment> {
        let fromQuery = query?.missingReferencedFragments ?? []
        let fromFragments = fragments.flatMap { $0.name.upperCamelized + $0.object.missingReferencedFragments(api: $0.api) }
        let fromConnectionQueries = connectionQueries.flatMap { $0.query.missingReferencedFragments }
        return fromQuery + fromFragments + fromConnectionQueries
    }

}

extension GraphQLFragment {

    var missingReferencedFragments: OrderedSet<MissingReferencedFragment> {
        return target.name.upperCamelized + object.missingReferencedFragments(api: api)
    }

}

extension GraphQLConnectionFragment {

    var missingReferencedFragments: OrderedSet<MissingReferencedFragment> {
        return fragment.name.upperCamelized + fragment.object.missingReferencedFragments(api: fragment.api)
    }

}

extension GraphQLQuery {

    var missingReferencedFragments: OrderedSet<MissingReferencedFragment> {
        return ["\(name)Query".upperCamelized, "Data"] + components
            .sorted { $0.key.field.name < $1.key.field.name }
            .flatMap { $0.value.missingReferencedFragments(field: $0.key, api: api) }
    }

}

extension GraphQLObject {

    func missingReferencedFragments(api: API) -> OrderedSet<MissingReferencedFragment> {
        let fromComponents = components
            .sorted { $0.key.field.name < $1.key.field.name }
            .flatMap { $0.value.missingReferencedFragments(field: $0.key, api: api) }

        let fragments = referencedFragments
            .filter { $0.hasArguments }
            .map { MissingReferencedFragment(api: api, path: [], fragmentName: $0.fragment.name.upperCamelized) }

        let fromTypeConditionals = typeConditionals
            .sorted { $0.key < $1.key }
            .flatMap { $0.value.missingReferencedFragments(api: api) }

        return OrderedSet(fragments + fromComponents + fromTypeConditionals)
    }

}

extension GraphQLTypeConditional {

    func missingReferencedFragments(api: API) -> OrderedSet<MissingReferencedFragment> {
        let name = "As \(type.name)"
        return name.singular.upperCamelized + object.missingReferencedFragments(api: api)
    }

}

extension GraphQLComponent {

    func missingReferencedFragments(field: GraphQLField, api: API) -> OrderedSet<MissingReferencedFragment> {
        switch self {
        case .object(let object):
            let name = field.alias ?? field.field.definition.name
            return name.singular.upperCamelized + object.missingReferencedFragments(api: api)
        default:
            return []
        }
    }

}

extension MissingReferencedFragment {

    static func + (lhs: String, rhs: MissingReferencedFragment) -> MissingReferencedFragment {
        return [lhs] + rhs
    }

    static func + (lhs: [String], rhs: MissingReferencedFragment) -> MissingReferencedFragment {
        return MissingReferencedFragment(api: rhs.api, path: lhs + rhs.path, fragmentName: rhs.fragmentName)
    }

}

func + (lhs: String, rhs: OrderedSet<MissingReferencedFragment>) -> OrderedSet<MissingReferencedFragment> {
    return OrderedSet(rhs.map { lhs + $0 })
}

func + (lhs: [String], rhs: OrderedSet<MissingReferencedFragment>) -> OrderedSet<MissingReferencedFragment> {
    return OrderedSet(rhs.map { lhs + $0 })
}

