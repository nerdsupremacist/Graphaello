//
//  GraphQLQuery.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 06.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

struct GraphQLQuery {
    let name: String
    let api: API
    let components: [Field : GraphQLComponent]
}

extension GraphQLQuery {

    var subFragments: [GraphQLFragment] {
        return components.values.flatMap { $0.subFragments }
    }

    var arguments: OrderedSet<GraphQLArgument> {
        return components.keys.flatMap { $0.arguments } +
            components.values.flatMap { $0.arguments }
    }

}

extension GraphQLQuery {
    
    static func + (lhs: GraphQLQuery, rhs: GraphQLQuery) throws -> GraphQLQuery {
        guard lhs.api.name == rhs.api.name else {
            throw GraphQLFragmentResolverError.cannotQueryDataFromTwoAPIsFromTheSameStruct(lhs.api, rhs.api)
        }
        let components = lhs.components.merging(rhs.components) { $0 + $1 }
        return GraphQLQuery(name: lhs.name,
                            api: lhs.api,
                            components: components)
    }
    
    static func + (lhs: GraphQLQuery?, rhs: GraphQLQuery) throws -> GraphQLQuery {
        return try lhs.map { try $0 + rhs } ?? rhs
    }
    
}
