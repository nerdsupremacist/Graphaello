//
//  FieldArgumentCleaner.swift
//  
//
//  Created by Mathias Quintero on 12/28/19.
//

import Foundation

struct FieldArgumentCleaner: ArgumentCleaner {

    func clean(resolved: GraphQLField,
               using context: Cleaning.Argument.Context) throws -> Cleaning.Argument.Result<GraphQLField> {

        return (context + resolved.field).map { GraphQLField(field: $0, alias: resolved.alias) }
    }

}
