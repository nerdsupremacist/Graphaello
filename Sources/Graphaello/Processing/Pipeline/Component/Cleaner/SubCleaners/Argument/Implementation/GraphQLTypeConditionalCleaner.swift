//
//  GraphQLTypeConditionalCleaner.swift
//  
//
//  Created by Mathias Quintero on 12/28/19.
//

import Foundation

struct GraphQLTypeConditionalCleaner: ArgumentCleaner {
    let objectCleaner: AnyArgumentCleaner<GraphQLObject>

    func clean(resolved: GraphQLTypeConditional,
               using context: Cleaning.Argument.Context) throws -> Cleaning.Argument.Result<GraphQLTypeConditional> {

        return try objectCleaner
            .clean(resolved: resolved.object, using: context).map { object in
                GraphQLTypeConditional(type: resolved.type, object: object)
            }
    }
}
