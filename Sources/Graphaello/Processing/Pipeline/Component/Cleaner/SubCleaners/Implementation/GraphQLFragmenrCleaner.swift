//
//  GraphQLFragmenrCleaner.swift
//  
//
//  Created by Mathias Quintero on 12/28/19.
//

import Foundation

struct GraphQLFragmenrCleaner: SubCleaner {
    let objectCleaner: AnyCleaner<GraphQLObject>

    func clean(resolved: GraphQLFragment,
               using context: Cleaning.Context) throws -> Cleaning.Result<GraphQLFragment> {

        return try objectCleaner
            .clean(resolved: resolved.object, using: context).map { object in
                GraphQLFragment(name: resolved.name,
                                api: resolved.api,
                                target: resolved.target,
                                object: object)
            }
    }
}
