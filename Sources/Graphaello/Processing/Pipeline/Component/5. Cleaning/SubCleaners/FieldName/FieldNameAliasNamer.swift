//
//  FieldNameAliasNamer.swift
//  
//
//  Created by Mathias Quintero on 02.01.20.
//

import Foundation

protocol FieldNameAliasNamer {
    func rename(field: GraphQLField, nonRenamable: [GraphQLField]) throws -> GraphQLField
}

extension FieldNameAliasNamer {
    
    func rename<T>(fields: [GraphQLField : T], nonRenamable: [GraphQLField]) throws -> [GraphQLField : T] {
        return try fields.reduce(into: [:]) { fields, element in
            let field = try rename(field: element.key, nonRenamable: Array(fields.keys))
            fields[field] = element.value
        }
    }
    
}
