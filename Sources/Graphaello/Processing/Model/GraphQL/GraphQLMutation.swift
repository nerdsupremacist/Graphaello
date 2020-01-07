//
//  GraphQLMutation.swift
//  
//
//  Created by Mathias Quintero on 1/7/20.
//

import Foundation

struct GraphQLMutation {
    let api: API
    let target: Schema.GraphQLType
    let name: String
    let object: GraphQLObject
    let referencedFragment: GraphQLFragment?
}

extension GraphQLMutation {

    var arguments: OrderedSet<GraphQLArgument> {
        return object.arguments
    }

}
