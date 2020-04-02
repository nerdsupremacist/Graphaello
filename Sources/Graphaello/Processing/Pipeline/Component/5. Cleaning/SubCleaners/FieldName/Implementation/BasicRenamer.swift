//
//  BasicFieldNameAliasNamer.swift
//  
//
//  Created by Mathias Quintero on 02.01.20.
//

import Foundation

struct BasicFieldNameAliasNamer: FieldNameAliasNamer {
    
    func rename(field: GraphQLField, nonRenamable: [GraphQLField]) throws -> GraphQLField {
        let nonRenamable = Dictionary(uniqueKeysWithValues: nonRenamable.map { ($0.name.singular, $0) })
        return rename(field: field, nonRenamable: nonRenamable)
    }
    
    private func rename(field: GraphQLField,
                        nonRenamable: [String : GraphQLField],
                        number: Int? = nil) -> GraphQLField {
        
        guard let sameName = nonRenamable[field.name.singular], field.field != sameName.field else { return field }
        
        let number = number ?? 1
        let newRenamed = GraphQLField(field: field.field, alias: "\(field.field.name)\(number)")
        return rename(field: newRenamed, nonRenamable: nonRenamable, number: number)
    }
    
}

extension GraphQLField {
    
    fileprivate var name: String {
        return alias ?? field.name
    }
    
}
