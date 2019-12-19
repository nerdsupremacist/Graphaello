//
//  GraphQLField.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 06.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

enum Field: Equatable, Hashable {
    case direct(Schema.GraphQLType.Field)
    case call(Schema.GraphQLType.Field, [String : Argument])
}

extension Field {
    
    var definition: Schema.GraphQLType.Field {
        switch self {
        case .direct(let field):
            return field
        case .call(let field, _):
            return field
        }
    }
    
    var name: String {
        return definition.name
    }
    
}

extension Field {

    var arguments: OrderedSet<GraphQLArgument> {
        switch self {

        case .direct:
            return []

        case .call(let field, let arguments):
            return OrderedSet(arguments.map { element in
                let type = field.arguments[element.key]?.type ?! fatalError()
                switch element.value {

                case .value(let expression):
                    return GraphQLArgument(name: element.key,
                                           type: type,
                                           defaultValue: expression,
                                           argument: element.value)

                case .argument(.withDefault(let expression)):
                    return GraphQLArgument(name: element.key,
                                           type: type,
                                           defaultValue: expression,
                                           argument: element.value)

                case .argument(.forced):
                    return GraphQLArgument(name: element.key,
                                           type: type,
                                           defaultValue: nil,
                                           argument: element.value)
                }
            })
        }
    }

}
