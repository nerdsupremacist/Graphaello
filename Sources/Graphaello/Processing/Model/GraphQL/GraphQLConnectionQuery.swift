//
//  GraphQLConnectionQuery.swift
//  
//
//  Created by Mathias Quintero on 12/20/19.
//

import Foundation

struct GraphQLConnectionQuery: Hashable {
    let query: GraphQLQuery
    let fragment: GraphQLConnectionFragment
    let propertyName: String
}
