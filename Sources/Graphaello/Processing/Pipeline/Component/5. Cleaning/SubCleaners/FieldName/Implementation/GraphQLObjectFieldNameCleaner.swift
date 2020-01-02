//
//  GraphQLObjectFieldNameCleaner.swift
//  
//
//  Created by Mathias Quintero on 02.01.20.
//

import Foundation

struct GraphQLObjectFieldNameCleaner: FieldNameCleaner {
    let renamer: FieldNameAliasNamer
    
    func clean(resolved: GraphQLObject,
               using context: Cleaning.FieldName.Context) throws -> Cleaning.FieldName.Result<GraphQLObject> {
        
        let fragments = resolved.fragments.map { context[$0] } as [GraphQLFragment]
        
        let typeConditionals = try resolved.typeConditionals.collect(using: context) { typeConditional, context in
            return try clean(resolved: typeConditional.object, using: context)
                .map { GraphQLTypeConditional(type: typeConditional.type, object: $0) }
        }

        let alreadyNamed = fragments.flatMap { $0.object.currentLevelFields } +
            typeConditionals.value.values.flatMap { $0.object.currentLevelFields }
        
        let renamed = try renamer.rename(fields: resolved.components, nonRenamable: alreadyNamed)
        let components = try renamed
            .collect(using: typeConditionals) { component, context -> Cleaning.FieldName.Result<GraphQLComponent> in
                switch component {
                case .scalar:
                    return context.result(value: component)
                case .object(let object):
                    return try clean(resolved: object, using: context).map { GraphQLComponent.object($0) }
                }
        }
        
        return components.map { components in
            return GraphQLObject(components: components,
                                 fragments: fragments,
                                 typeConditionals: typeConditionals.value,
                                 arguments: resolved.arguments)
        }
    }
    
}

extension GraphQLObjectFieldNameCleaner {
    
    init(renamer: () -> FieldNameAliasNamer) {
        self.init(renamer: renamer())
    }
    
}

extension GraphQLObject {
    
    fileprivate var currentLevelFields: [GraphQLField] {
        let own = components.keys
        let fromFragments = fragments.flatMap { $0.object.currentLevelFields }
        let fromTypeConditionals = typeConditionals.values.flatMap { $0.object.currentLevelFields }
        return own + fromFragments + fromTypeConditionals
    }
    
}
