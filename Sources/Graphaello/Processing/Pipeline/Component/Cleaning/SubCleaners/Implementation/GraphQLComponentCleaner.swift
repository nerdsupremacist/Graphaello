//
//  GraphQLComponentCleaner.swift
//  
//
//  Created by Mathias Quintero on 12/28/19.
//

import Foundation

struct GraphQLComponentCleaner: SubCleaner {
    let objectCleaner: AnyCleaner<GraphQLObject>

    func clean(resolved: GraphQLComponent,
               using context: Cleaning.Context) throws -> Cleaning.Result<GraphQLComponent> {

        switch resolved {
        case .scalar:
            return context.result(value: resolved)
        case .object(let object):
            return try objectCleaner
                .clean(resolved: object, using: context).map { object in
                    .object(object)
                }
        }
    }
}
