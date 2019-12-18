//
//  GraphQLArgument.swift
//  
//
//  Created by Mathias Quintero on 12/18/19.
//

import Foundation
import SwiftSyntax

struct GraphQLArgument: Hashable {
    let name: String
    let type: Schema.GraphQLType.Field.TypeReference
    let defaultValue: ExprSyntax?

    static func == (lhs: GraphQLArgument, rhs: GraphQLArgument) -> Bool {
        return lhs.name == rhs.name &&
            lhs.type == rhs.type &&
            lhs.defaultValue?.description == rhs.defaultValue?.description
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(type)
        hasher.combine(defaultValue?.description)
    }
}

