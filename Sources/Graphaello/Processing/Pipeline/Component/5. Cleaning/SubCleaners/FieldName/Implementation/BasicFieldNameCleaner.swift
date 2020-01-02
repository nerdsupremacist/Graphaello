//
//  BasicFieldNameCleaner.swift
//  
//
//  Created by Mathias Quintero on 02.01.20.
//

import Foundation

struct BasicFieldNameCleaner: FieldNameCleaner {
    let fragmentCleaner: AnyFieldNameCleaner<GraphQLFragment>
    let queryCleaner: AnyFieldNameCleaner<GraphQLQuery>
    
    func clean(resolved: Struct<Stage.Resolved>,
               using context: Cleaning.FieldName.Context) throws -> Cleaning.FieldName.Result<Struct<Stage.Resolved>> {
        
        let connectionFragments = try resolved
            .connectionQueries
            .map { $0.fragment.fragment }
            .collect(using: context) { try fragmentCleaner.clean(resolved: $0, using: $1) }
        
        let query = try queryCleaner.clean(resolved: resolved.query, using: connectionFragments)
        let fragments = try resolved.fragments.collect(using: query) { try fragmentCleaner.clean(resolved: $0, using: $1) }
        
        let connectionQueries = try resolved.connectionQueries.collect(using: fragments) { query, context -> Cleaning.FieldName.Result<GraphQLConnectionQuery> in
            let nodeFragment = context[query.fragment.nodeFragment]
            let fragment = context[query.fragment.fragment]
            return try queryCleaner
                .clean(resolved: query.query, using: context)
                .map { GraphQLConnectionQuery(query: $0,
                                              fragment: GraphQLConnectionFragment(connection: query.fragment.connection,
                                                                                  edgeType: query.fragment.edgeType,
                                                                                  nodeFragment: nodeFragment,
                                                                                  fragment: fragment)) }
        }
        
        return connectionQueries.map { connectionQueries in
            resolved.with {
                (.query ~> query.value)
                (.fragments ~> fragments.value)
                (.connectionQueries ~> connectionQueries)
            }
        }
    }
    
}


extension BasicFieldNameCleaner {
    
    init(objectCleaner: AnyFieldNameCleaner<GraphQLObject>,
         fragmentCleaner: (AnyFieldNameCleaner<GraphQLObject>) -> AnyFieldNameCleaner<GraphQLFragment>,
         queryCleaner: (AnyFieldNameCleaner<GraphQLObject>) -> AnyFieldNameCleaner<GraphQLQuery>) {
        
        self.init(fragmentCleaner: fragmentCleaner(objectCleaner), queryCleaner: queryCleaner(objectCleaner))
    }
    
}
