//
//  GraphQLQueryCleaner.swift
//  
//
//  Created by Mathias Quintero on 12/28/19.
//

import Foundation

struct GraphQLQueryCleaner: ArgumentCleaner {
    let componentsCleaner: AnyArgumentCleaner<[GraphQLField : GraphQLComponent]>

    func clean(resolved: GraphQLQuery,
               using context: Cleaning.Argument.Context) throws -> Cleaning.Argument.Result<GraphQLQuery> {

        return try componentsCleaner
            .clean(resolved: resolved.components, using: context)
            .map { components in
                GraphQLQuery(name: resolved.name,
                             api: resolved.api,
                             components: components)
            }
    }
}
