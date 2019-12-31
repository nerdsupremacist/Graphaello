//
//  Resolved+Struct+Concat.swift
//  
//
//  Created by Mathias Quintero on 31.12.19.
//

import Foundation

extension Struct where CurrentStage: ResolvedStage {
    
    static func + (lhs: Struct<CurrentStage>, rhs: GraphQLFragment) -> Struct<CurrentStage> {
        let includesFragment = lhs.fragments.contains { $0 ~= rhs }
        if includesFragment {
            let fragments = lhs.fragments.map { $0 ~= rhs ? $0 + rhs : $0 } as [GraphQLFragment]
            return lhs.with { .fragments ~> fragments }
        } else {
            return lhs.with { .fragments ~> (lhs.fragments + [rhs]) }
        }
    }
    
    static func + (lhs: Struct<CurrentStage>, rhs: GraphQLQuery) throws -> Struct<CurrentStage> {
        return try lhs.with { try .query ~> (lhs.query + rhs) }
    }

    static func + (lhs: Struct<CurrentStage>, rhs: GraphQLConnectionQuery) -> Struct<CurrentStage> {
        return lhs.with { .connectionQueries ~> (lhs.connectionQueries + [rhs]) }
    }
    
}
