//
//  GraphQLObjectCleaner.swift
//  
//
//  Created by Mathias Quintero on 1/1/19.
//

import Foundation

struct GraphQLObjectCleaner: ArgumentCleaner {
    let argumentCleaner: AnyArgumentCleaner<GraphQLArgument>
    let componentsCleaner: (AnyArgumentCleaner<GraphQLObject>) -> AnyArgumentCleaner<[GraphQLField : GraphQLComponent]>
    let fragmentCleaner: (AnyArgumentCleaner<GraphQLObject>) -> AnyArgumentCleaner<GraphQLFragment>
    let typeConditionalCleaner: (AnyArgumentCleaner<GraphQLObject>) -> AnyArgumentCleaner<GraphQLTypeConditional>

    func clean(resolved: GraphQLObject,
               using context: Cleaning.Argument.Context) throws -> Cleaning.Argument.Result<GraphQLObject> {
        
        let cleaner = any()
        let componentsCleaner = self.componentsCleaner(cleaner)
        let fragmentCleaner = self.fragmentCleaner(cleaner)
        let typeConditionalCleaner = self.typeConditionalCleaner(cleaner)

        let arguments = try resolved
            .arguments
            .collect(using: context) { try argumentCleaner.clean(resolved: $0, using: $1) }

        let components = try componentsCleaner.clean(resolved: resolved.components, using: arguments)

        let fragments = try resolved
            .fragments
            .collect(using: components) { try fragmentCleaner.clean(resolved: $0, using: $1) }

        let typeConditionals = try resolved
            .typeConditionals
            .collect(using: fragments) { try typeConditionalCleaner.clean(resolved: $0, using: $1) }

        return typeConditionals.map { typeConditionals in
            GraphQLObject(components: components.value,
                          fragments: fragments.value,
                          typeConditionals: typeConditionals,
                          arguments: arguments.value)
        }
    }

}
