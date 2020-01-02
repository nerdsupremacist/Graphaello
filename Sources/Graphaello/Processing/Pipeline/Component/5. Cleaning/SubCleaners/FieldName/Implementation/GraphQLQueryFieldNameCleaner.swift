//
//  File.swift
//  
//
//  Created by Mathias Quintero on 02.01.20.
//

import Foundation

struct GraphQLQueryFieldNameCleaner: FieldNameCleaner {
    let objectCleaner: AnyFieldNameCleaner<GraphQLObject>
    
    func clean(resolved: GraphQLQuery, using context: Cleaning.FieldName.Context) throws -> Cleaning.FieldName.Result<GraphQLQuery> {
        let object = GraphQLObject(components: resolved.components,
                                   fragments: [],
                                   typeConditionals: [:],
                                   arguments: resolved.arguments)
        
        return try objectCleaner.clean(resolved: object,
                                       using: context).map { object in
            
            GraphQLQuery(name: resolved.name, api: resolved.api, components: object.components)
        }
    }
}
