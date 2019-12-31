//
//  GraphQLArgumentCleaner.swift
//  
//
//  Created by Mathias Quintero on 1/1/19.
//

import Foundation

struct GraphQLArgumentCleaner: SubCleaner {
    func clean(resolved: GraphQLArgument,
               using context: Cleaning.Context) throws -> Cleaning.Result<GraphQLArgument> {

        return context + resolved
    }
}
