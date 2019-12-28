//
//  GraphQLConnectionQueryCleaner.swift
//  
//
//  Created by Mathias Quintero on 12/28/19.
//

import Foundation

struct GraphQLConnectionQueryCleaner: SubCleaner {
    let queryCleaner: AnyCleaner<GraphQLQuery>

    func clean(resolved: GraphQLConnectionQuery,
               using context: Cleaning.Context) throws -> Cleaning.Result<GraphQLConnectionQuery> {

        return try queryCleaner
            .clean(resolved: resolved.query, using: context)
            .map { query in
                GraphQLConnectionQuery(query: query,
                                       fragment: resolved.fragment)
            }
    }
}
