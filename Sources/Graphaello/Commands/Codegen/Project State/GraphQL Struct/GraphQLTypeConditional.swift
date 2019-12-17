//
//  GraphQLTypeConditional.swift
//  
//
//  Created by Mathias Quintero on 12/17/19.
//

import Foundation

struct GraphQLTypeConditional {
    let type: Schema.GraphQLType
    let object: GraphQLObject
}

extension GraphQLTypeConditional {

    static func + (lhs: GraphQLTypeConditional, rhs: GraphQLTypeConditional) -> GraphQLTypeConditional {
        assert(lhs.type.name == rhs.type.name)
        return GraphQLTypeConditional(type: lhs.type,
                                      object: lhs.object + rhs.object)
    }

}
