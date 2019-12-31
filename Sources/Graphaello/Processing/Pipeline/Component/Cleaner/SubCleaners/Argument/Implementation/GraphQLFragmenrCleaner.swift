//
//  GraphQLFragmenrCleaner.swift
//  
//
//  Created by Mathias Quintero on 12/28/19.
//

import Foundation

struct GraphQLFragmenrCleaner: ArgumentCleaner {
    let objectCleaner: AnyArgumentCleaner<GraphQLObject>

    func clean(resolved: GraphQLFragment,
               using context: Cleaning.Argument.Context) throws -> Cleaning.Argument.Result<GraphQLFragment> {

        return try objectCleaner
            .clean(resolved: resolved.object, using: context).map { object in
                GraphQLFragment(name: resolved.name,
                                api: resolved.api,
                                target: resolved.target,
                                object: object)
            }
    }
}
