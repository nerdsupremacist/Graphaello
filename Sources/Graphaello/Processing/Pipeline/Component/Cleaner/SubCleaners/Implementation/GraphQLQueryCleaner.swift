//
//  GraphQLQueryCleaner.swift
//  
//
//  Created by Mathias Quintero on 12/28/19.
//

import Foundation

struct GraphQLQueryCleaner: SubCleaner {
    let componentsCleaner: AnyCleaner<[Field : GraphQLComponent]>

    func clean(resolved: GraphQLQuery,
               using context: Cleaning.Context) throws -> Cleaning.Result<GraphQLQuery> {

        return try componentsCleaner
            .clean(resolved: resolved.components, using: context)
            .map { components in
                GraphQLQuery(name: resolved.name,
                             api: resolved.api,
                             components: components)
            }
    }
}
