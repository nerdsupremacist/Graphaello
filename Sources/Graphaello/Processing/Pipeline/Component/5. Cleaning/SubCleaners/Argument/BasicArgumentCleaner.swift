//
//  BasicArgumentCleaner.swift
//  
//
//  Created by Mathias Quintero on 31.12.19.
//

import Foundation

struct BasicArgumentCleaner: ArgumentCleaner {
    let queryCleaner: AnyArgumentCleaner<GraphQLQuery>
    let connectionQueryCleaner: AnyArgumentCleaner<GraphQLConnectionQuery>
    
    func clean(resolved: Struct<Stage.Resolved>,
               using context: Cleaning.Argument.Context) throws -> Cleaning.Argument.Result<Struct<Stage.Resolved>> {
        
        
        let query = try queryCleaner.clean(resolved: resolved.query, using: .empty)
        let connectionQueries = try resolved.connectionQueries.collect(using: query) { try connectionQueryCleaner.clean(resolved: $0, using: $1) }
        
        return connectionQueries.map { connectionQueries in
            resolved.with {
                .query ~> query.value;
                .connectionQueries ~> connectionQueries;
            }
        }
    }
}

extension BasicArgumentCleaner {

    typealias CleanerFactory<T> = (AnyArgumentCleaner<GraphQLObject>) -> AnyArgumentCleaner<T>
    typealias ObjectCleanerFactory = (
        AnyArgumentCleaner<GraphQLArgument>,
        @escaping CleanerFactory<[GraphQLField : GraphQLComponent]>,
        @escaping CleanerFactory<GraphQLFragment>,
        @escaping CleanerFactory<GraphQLTypeConditional>
    ) -> AnyArgumentCleaner<GraphQLObject>

    init(argumentCleaner: AnyArgumentCleaner<GraphQLArgument>,
         fieldCleaner: AnyArgumentCleaner<GraphQLField>,
         componentCleaner: @escaping CleanerFactory<GraphQLComponent>,
         fragmentCleaner: @escaping CleanerFactory<GraphQLFragment>,
         typeConditionalCleaner: @escaping CleanerFactory<GraphQLTypeConditional>,
         objectCleaner: ObjectCleanerFactory,
         queryCleaner: (AnyArgumentCleaner<[GraphQLField : GraphQLComponent]>) -> AnyArgumentCleaner<GraphQLQuery>,
         connectionQueryCleaner: (AnyArgumentCleaner<GraphQLQuery>) -> AnyArgumentCleaner<GraphQLConnectionQuery>) {

        let componentsCleaner = { DictionaryCleaner(keyCleaner: fieldCleaner, valueCleaner: componentCleaner($0)).any() }
        let objectCleaner = objectCleaner(argumentCleaner, componentsCleaner, fragmentCleaner, typeConditionalCleaner)
        let queryCleaner = queryCleaner(componentsCleaner(objectCleaner))

        let connectionQueryCleaner = connectionQueryCleaner(queryCleaner)

        self.init(queryCleaner: queryCleaner,
                  connectionQueryCleaner: connectionQueryCleaner)
    }

}
