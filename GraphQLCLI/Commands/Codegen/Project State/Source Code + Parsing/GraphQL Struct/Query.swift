//
//  GraphQLQuery.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 06.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

struct GraphQLQuery {
    let api: API
    let components: [Field : GraphQLComponent]
}

extension GraphQLQuery {
    
    static func + (lhs: GraphQLQuery, rhs: GraphQLQuery) -> GraphQLQuery {
        let components = lhs.components.merging(rhs.components) { $0 + $1 }
        return GraphQLQuery(api: lhs.api,
                            components: components)
    }
    
    static func + (lhs: GraphQLQuery?, rhs: GraphQLQuery) -> GraphQLQuery {
        return lhs.map { $0 + rhs } ?? rhs
    }
    
}
