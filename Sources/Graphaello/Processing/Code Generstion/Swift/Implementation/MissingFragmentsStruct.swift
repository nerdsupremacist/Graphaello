//
//  MissingFragmentsStruct.swift
//  
//
//  Created by Mathias Quintero on 12/19/19.
//

import Foundation

struct MissingFragmentsStruct: SwiftCodeTransformable, Hashable {
    let path: [String]
}

extension Struct where CurrentStage == Stage.Resolved{

    var missingFragmentsStructs: OrderedSet<MissingFragmentsStruct> {
        let fromQuery = query?.missingFragmentsStructs ?? []
        let fromFragments = fragments.flatMap { $0.missingFragmentsStructs }
        let fromConnectionQueries = connectionQueries.flatMap { $0.query.missingFragmentsStructs }
        return fromQuery + fromFragments + fromConnectionQueries
    }

}

extension GraphQLFragment {

    var missingFragmentsStructs: OrderedSet<MissingFragmentsStruct> {
        return target.name.upperCamelized + object.missingFragmentsStructs
    }

}

extension GraphQLConnectionFragment {

    var missingFragmentsStructs: OrderedSet<MissingFragmentsStruct> {
        return fragment.name.upperCamelized + fragment.object.missingFragmentsStructs
    }

}

extension GraphQLQuery {

    var missingFragmentsStructs: OrderedSet<MissingFragmentsStruct> {
        return ["\(name)Query".upperCamelized, "Data"] + components
            .sorted { $0.key.name < $1.key.name }
            .flatMap { $0.value.missingFragmentsStructs(field: $0.key) }
    }

}

extension GraphQLObject {

    var missingFragmentsStructs: OrderedSet<MissingFragmentsStruct> {
        let fromComponents = components
            .sorted { $0.key.name < $1.key.name }
            .flatMap { $0.value.missingFragmentsStructs(field: $0.key) }

        if referencedFragments.isEmpty {
            return fromComponents
        }

        if referencedFragments.contains(where: { !$0.hasArguments }) {
            return fromComponents
        }

        return [MissingFragmentsStruct(path: [])] + fromComponents
    }

}

extension GraphQLComponent {

    func missingFragmentsStructs(field: Field) -> OrderedSet<MissingFragmentsStruct> {
        switch self {
        case .object(let object):
            return field.definition.name.singular.upperCamelized + object.missingFragmentsStructs
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
        return MissingFragmentsStruct(path: lhs + rhs.path)
    }

}

func + (lhs: String, rhs: OrderedSet<MissingFragmentsStruct>) -> OrderedSet<MissingFragmentsStruct> {
    return OrderedSet(rhs.map { lhs + $0 })
}

func + (lhs: [String], rhs: OrderedSet<MissingFragmentsStruct>) -> OrderedSet<MissingFragmentsStruct> {
    return OrderedSet(rhs.map { lhs + $0 })
}

