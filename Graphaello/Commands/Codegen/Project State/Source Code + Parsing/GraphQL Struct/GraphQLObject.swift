//
//  GraphQLObject.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 06.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

struct GraphQLObject {
    let components: [Field : GraphQLComponent]
    let fragments: [String : GraphQLFragment]
}

extension GraphQLObject {
    
    static func + (lhs: GraphQLObject, rhs: GraphQLObject) -> GraphQLObject {
        let components = lhs.components.merging(rhs.components) { $0 + $1 }
        let fragments = lhs.fragments.merging(rhs.fragments) { $1 }
        return GraphQLObject(components: components, fragments: fragments)
    }
    
}
