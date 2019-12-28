//
//  GraphQLObjectCleaner.swift
//  
//
//  Created by Mathias Quintero on 1/1/19.
//

import Foundation

struct GraphQLObjectCleaner: SubCleaner {
    let argumentCleaner: AnyCleaner<GraphQLArgument>
    let componentsCleaner: (AnyCleaner<GraphQLObject>) -> AnyCleaner<[Field : GraphQLComponent]>
    let fragmentCleaner: (AnyCleaner<GraphQLObject>) -> AnyCleaner<GraphQLFragment>
    let typeConditionalCleaner: (AnyCleaner<GraphQLObject>) -> AnyCleaner<GraphQLTypeConditional>

    func clean(resolved: GraphQLObject, using context: Cleaning.Context) throws -> Cleaning.Result<GraphQLObject> {
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
