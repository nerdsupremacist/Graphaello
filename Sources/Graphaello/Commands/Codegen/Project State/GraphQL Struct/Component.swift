//
//  Component.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 06.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

indirect enum GraphQLComponent {
    case scalar(propertyNames: Set<String>)
    case object(GraphQLObject)
}

extension GraphQLComponent {

    var subFragments: [GraphQLFragment] {
        switch self {
        case .scalar:
            return []
        case .object(let object):
            return object.subFragments
        }
    }

    var arguments: OrderedSet<GraphQLArgument> {
        switch self {
        case .object(let object):
            return object.arguments
        case .scalar:
            return []
        }
    }

}

extension GraphQLComponent {
    
    static func + (lhs: GraphQLComponent, rhs: GraphQLComponent) -> GraphQLComponent {
        switch (lhs, rhs) {
        case (.scalar(let lhs), .scalar(let rhs)):
            return .scalar(propertyNames: lhs.union(rhs))
        case (.object(let lhs), .object(let rhs)):
            return .object(lhs + rhs)
        default:
            fatalError()
        }
    }
    
}
