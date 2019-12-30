//
//  GraphQLObject.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 06.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

struct GraphQLObject: Hashable {
    let components: [Field : GraphQLComponent]
    let fragments: [GraphQLFragment]
    let typeConditionals: [String : GraphQLTypeConditional]
    let arguments: OrderedSet<GraphQLArgument>
}

extension GraphQLObject {

    init(components: [Field : GraphQLComponent],
         fragments: [GraphQLFragment],
         typeConditionals: [String : GraphQLTypeConditional]) {

        self.components = components
        self.fragments = fragments
        self.typeConditionals = typeConditionals

        let currentLevel = components.keys.flatMap { $0.arguments }
        let fromComponents = components.values.flatMap { $0.arguments }
        let fromFragmented = fragments.flatMap { $0.arguments }
        let fromTypeConditional = typeConditionals.values.flatMap { $0.arguments }
        self.arguments = currentLevel + fromComponents + fromFragmented + fromTypeConditional
    }

}

extension GraphQLObject {
    
    static func + (lhs: GraphQLObject, rhs: GraphQLObject) -> GraphQLObject {
        let components = lhs.components.merging(rhs.components) { $0 + $1 }
        let fragments = lhs.fragments + rhs.fragments
        let typeConditional = lhs.typeConditionals.merging(rhs.typeConditionals) { $0 + $1 }
        return GraphQLObject(components: components, fragments: fragments, typeConditionals: typeConditional)
    }
    
}
