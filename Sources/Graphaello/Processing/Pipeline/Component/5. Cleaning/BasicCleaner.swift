//
//  BasicCleaner.swift
//  
//
//  Created by Mathias Quintero on 12/28/19.
//

import Foundation

struct BasicCleaner: Cleaner {
    let argumentCleaner: AnyArgumentCleaner<Struct<Stage.Resolved>>
    let fieldNameCleaner: AnyFieldNameCleaner<Struct<Stage.Resolved>>
    let aliasPropagator: PropertyAliasingPropagator

    func clean(resolved: [Struct<Stage.Resolved>]) throws -> [Struct<Stage.Cleaned>] {
        let cleanedFieldNames = try resolved.collect(using: .empty) { try fieldNameCleaner.clean(resolved: $0, using: $1) }.value
        let cleanedArguments = try cleanedFieldNames.map { try argumentCleaner.clean(resolved: $0) }
        return try cleanedArguments
            .map { cleaned in
                let properties = try cleaned.properties.map { try aliasPropagator.propagate(property: $0, from: cleaned) }
                return cleaned.with(properties: properties)
            }
    }
}

extension BasicCleaner {

    init(argumentCleaner: () -> AnyArgumentCleaner<Struct<Stage.Resolved>>,
         fieldNameCleaner: () -> AnyFieldNameCleaner<Struct<Stage.Resolved>>,
         aliasPropagator: () -> PropertyAliasingPropagator) {
        
        self.init(argumentCleaner: argumentCleaner(),
                  fieldNameCleaner: fieldNameCleaner(),
                  aliasPropagator: aliasPropagator())
    }

}
