//
//  GraphQLArgumentCleaner.swift
//  
//
//  Created by Mathias Quintero on 1/1/19.
//

import Foundation

struct GraphQLArgumentCleaner: ArgumentCleaner {
    func clean(resolved: GraphQLArgument,
               using context: Cleaning.Argument.Context) throws -> Cleaning.Argument.Result<GraphQLArgument> {

        return context + resolved
    }
}
