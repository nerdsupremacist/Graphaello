//
//  Struct.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 12/1/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SwiftSyntax

struct GraphQLPath {
    enum Target {
        case query
        case object(String)
    }

    enum Component {
        enum Argument {
            enum QueryArgument {
                case withDefault(ExprSyntax)
                case forced
            }

            case value(ExprSyntax)
            case argument(QueryArgument)
        }

        case property(String)
        case fragment
        case call(String, [String : Argument])
    }

    let apiName: String
    let target: Target
    let path: [Component]
}

struct Property {
    let name: String
    let type: String
    let graphqlPath: GraphQLPath?
}

struct Struct {
    let name: String
    let properties: [Property]
}

extension Struct {

    var hasGraphQLValues: Bool {
        return properties.contains { $0.graphqlPath != nil }
    }

}
