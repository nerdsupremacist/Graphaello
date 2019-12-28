//
//  BasicCleaner.swift
//  
//
//  Created by Mathias Quintero on 12/28/19.
//

import Foundation

struct BasicCleaner: Cleaner {
    let queryCleaner: AnyCleaner<GraphQLQuery>
    let connectionQueryCleaner: AnyCleaner<GraphQLConnectionQuery>

    func clean(resolved: GraphQLStruct) throws -> GraphQLStruct {
        let query = try queryCleaner.clean(resolved: resolved.query, using: .empty)
        let connectionQueries = try resolved.connectionQueries.collect(using: query) { try connectionQueryCleaner.clean(resolved: $0, using: $1) }
        return GraphQLStruct(definition: resolved.definition,
                             fragments: resolved.fragments,
                             query: query.value,
                             connectionQueries: connectionQueries.value)
    }
}

extension BasicCleaner {

    typealias CleanerFactory<T> = (AnyCleaner<GraphQLObject>) -> AnyCleaner<T>
    typealias ObjectCleanerFactory = (
        AnyCleaner<GraphQLArgument>,
        @escaping CleanerFactory<[Field : GraphQLComponent]>,
        @escaping CleanerFactory<GraphQLFragment>,
        @escaping CleanerFactory<GraphQLTypeConditional>
    ) -> AnyCleaner<GraphQLObject>

    init(argumentCleaner: AnyCleaner<GraphQLArgument>,
         fieldCleaner: AnyCleaner<Field>,
         componentCleaner: @escaping CleanerFactory<GraphQLComponent>,
         fragmentCleaner: @escaping CleanerFactory<GraphQLFragment>,
         typeConditionalCleaner: @escaping CleanerFactory<GraphQLTypeConditional>,
         objectCleaner: ObjectCleanerFactory,
         queryCleaner: (AnyCleaner<[Field : GraphQLComponent]>) -> AnyCleaner<GraphQLQuery>,
         connectionQueryCleaner: (AnyCleaner<GraphQLQuery>) -> AnyCleaner<GraphQLConnectionQuery>) {

        let componentsCleaner = { DictionaryCleaner(keyCleaner: fieldCleaner, valueCleaner: componentCleaner($0)).any() }
        let objectCleaner = objectCleaner(argumentCleaner, componentsCleaner, fragmentCleaner, typeConditionalCleaner)
        let queryCleaner = queryCleaner(componentsCleaner(objectCleaner))

        let connectionQueryCleaner = connectionQueryCleaner(queryCleaner)

        self.init(queryCleaner: queryCleaner,
                  connectionQueryCleaner: connectionQueryCleaner)
    }

}
