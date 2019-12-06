//
//  GraphQLStruct.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 06.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

struct GraphQLStruct {
    let definition: Struct
    let fragments: [GraphQLFragment]
    let query: GraphQLQuery?
}

extension GraphQLStruct {
    
    static func + (lhs: GraphQLStruct, rhs: GraphQLFragment) -> GraphQLStruct {
        let includesFragment = lhs.fragments.contains { $0 ~= rhs }
        if includesFragment {
            let fragments = lhs.fragments.map { $0 ~= rhs ? $0 + rhs : $0 }
            return GraphQLStruct(definition: lhs.definition, fragments: fragments, query: lhs.query)
        } else {
            return GraphQLStruct(definition: lhs.definition, fragments: lhs.fragments + [rhs], query: lhs.query)
        }
    }
    
    static func + (lhs: GraphQLStruct, rhs: GraphQLQuery) -> GraphQLStruct {
        return GraphQLStruct(definition: lhs.definition, fragments: lhs.fragments, query: lhs.query + rhs)
    }
    
}
