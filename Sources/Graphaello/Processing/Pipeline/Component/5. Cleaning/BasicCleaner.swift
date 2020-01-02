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

    func clean(resolved: [Struct<Stage.Resolved>]) throws -> [Struct<Stage.Cleaned>] {
        let cleanedFieldNames = try resolved.collect(using: .empty) { try fieldNameCleaner.clean(resolved: $0, using: $1) }.value
        let cleanedArguments = try cleanedFieldNames.map { try argumentCleaner.clean(resolved: $0) }
        return cleanedArguments.map {
            $0.with(properties: $0.properties.map { $0.map { Stage.Cleaned.Path(resolved: $0, components: $0.validated.components.map { Stage.Cleaned.Component(validated: $0, alias: nil) }) } })
        } // TODO: pass the properties
    }
}

extension BasicCleaner {

    init(argumentCleaner: () -> AnyArgumentCleaner<Struct<Stage.Resolved>>,
         fieldNameCleaner: () -> AnyFieldNameCleaner<Struct<Stage.Resolved>>) {
        
        self.init(argumentCleaner: argumentCleaner(), fieldNameCleaner: fieldNameCleaner())
    }

}
