//
//  MissingReferencedFragment.swift
//
//
//  Created by Mathias Quintero on 12/19/19.
//

import Foundation

struct MissingReferencedFragment: SwiftCodeTransformable, Hashable {
    let path: [String]
    let fragmentName: String
}

extension GraphQLStruct {

    var missingReferencedFragments: OrderedSet<MissingReferencedFragment> {
        let fromQuery = query?.missingReferencedFragments ?? []
        let fromFragments = fragments.flatMap { $0.missingReferencedFragments }
        return fromQuery + fromFragments
    }

}

extension GraphQLFragment {

    var missingReferencedFragments: OrderedSet<MissingReferencedFragment> {
        return target.name + object.missingReferencedFragments
    }

}

extension GraphQLQuery {

    var missingReferencedFragments: OrderedSet<MissingReferencedFragment> {
        return ["\(name)Query", "Data"] + components
            .sorted { $0.key.name < $1.key.name }
            .flatMap { $0.value.missingReferencedFragments(field: $0.key) }
    }

}

extension GraphQLObject {

    var missingReferencedFragments: OrderedSet<MissingReferencedFragment> {
        let fromComponents = components
            .sorted { $0.key.name < $1.key.name }
            .flatMap { $0.value.missingReferencedFragments(field: $0.key) }

        let fragments = referencedFragments
            .filter { $0.hasArguments }
            .map { MissingReferencedFragment(path: [], fragmentName: $0.fragment.name) }

        return OrderedSet(fragments + fromComponents)
    }

}

extension GraphQLComponent {

    func missingReferencedFragments(field: Field) -> OrderedSet<MissingReferencedFragment> {
        switch self {
        case .object(let object):
            return field.definition.name.upperCamelized + object.missingReferencedFragments
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
        return MissingReferencedFragment(path: lhs + rhs.path, fragmentName: rhs.fragmentName)
    }

}

func + (lhs: String, rhs: OrderedSet<MissingReferencedFragment>) -> OrderedSet<MissingReferencedFragment> {
    return OrderedSet(rhs.map { lhs + $0 })
}

func + (lhs: [String], rhs: OrderedSet<MissingReferencedFragment>) -> OrderedSet<MissingReferencedFragment> {
    return OrderedSet(rhs.map { lhs + $0 })
}

