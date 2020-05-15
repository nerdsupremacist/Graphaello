import Foundation

struct BasicCleaner: Cleaner {
    let argumentCleaner: AnyArgumentCleaner<Struct<Stage.Resolved>>
    let fieldNameCleaner: AnyFieldNameCleaner<Struct<Stage.Resolved>>
    let aliasPropagator: PropertyAliasingPropagator

    func clean(resolved: [Struct<Stage.Resolved>]) throws -> [Struct<Stage.Cleaned>] {
        let cleanedFieldNames = try resolved.collect(using: .empty) { resolved, context in
            try locateErrors(with: resolved.code.location) {
                try fieldNameCleaner.clean(resolved: resolved, using: context)
            }
        }.value
        let cleanedArguments = try cleanedFieldNames.map { resolved in
            try locateErrors(with: resolved.code.location) {
                try argumentCleaner.clean(resolved: resolved)
            }
        }
        return try cleanedArguments
            .map { cleaned in
                let properties = try cleaned.properties.map { property in
                    try locateErrors(with: property.code.location) {
                        try aliasPropagator.propagate(property: property, from: cleaned)
                    }
                }
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
