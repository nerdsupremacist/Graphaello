//
//  Struct.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 12/1/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SourceKittenFramework

struct GraphQLPath {
    enum Target {
        case query
        case object(String)
    }

    enum Component {
        enum Argument {
            enum QueryArgument {
                case withDefault(SourceCode)
                case forced
            }

            case value(SourceCode)
            case argument(QueryArgument)
        }

        case property(String)
        case fragment
        case call(String, call: [String : Argument])
    }

    let code: SourceCode
    let apiName: String
    let target: Target
    let path: [Component]
}

struct Property {
    let code: SourceCode
    let name: String
    let type: String
    let graphqlPath: GraphQLPath?
}

struct Struct {
    let code: SourceCode
    let name: String
    let properties: [Property]
}
