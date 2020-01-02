//
//  FragmentFieldNameCleaner.swift
//  
//
//  Created by Mathias Quintero on 02.01.20.
//

import Foundation

struct FragmentFieldNameCleaner: FieldNameCleaner {
    let objectCleaner: AnyFieldNameCleaner<GraphQLObject>
    
    func clean(resolved: GraphQLFragment,
               using context: Cleaning.FieldName.Context) throws -> Cleaning.FieldName.Result<GraphQLFragment> {
        
        return try objectCleaner.clean(resolved: resolved.object,
                                       using: context).flatMap { object, context in
            
            return context + GraphQLFragment(name: resolved.name, api: resolved.api, target: resolved.target, object: object)
        }
    }
}
