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
    let argument: Argument

    static func == (lhs: GraphQLArgument, rhs: GraphQLArgument) -> Bool {
        return lhs.name == rhs.name &&
            lhs.type == rhs.type &&
            lhs.defaultValue?.description == rhs.defaultValue?.description &&
            lhs.argument == rhs.argument
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(type)
        hasher.combine(defaultValue?.description)
        hasher.combine(argument)
    }
}

