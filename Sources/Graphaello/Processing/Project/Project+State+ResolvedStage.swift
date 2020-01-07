//
//  Project+State+ResolvedStage.swift
//  
//
//  Created by Mathias Quintero on 31.12.19.
//

import Foundation

extension Project.State where CurrentStage: ResolvedStage {

    var allConnectionQueries: OrderedSet<GraphQLConnectionQuery> {
        return structs.flatMap { OrderedSet($0.connectionQueries) }
    }

    var allConnectionFragments: OrderedSet<GraphQLConnectionFragment> {
        return allConnectionQueries.map { $0.fragment }
    }

    var allFragments: [GraphQLFragment] {
        return structs.flatMap { $0.fragments }
    }

    var allQueries: [GraphQLQuery] {
        return structs.compactMap { $0.query }
    }

    var allMutations: [GraphQLMutation] {
        return structs.flatMap { $0.mutations }
    }

}
