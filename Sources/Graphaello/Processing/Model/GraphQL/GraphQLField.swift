//
//  GraphQLField.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 06.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

typealias GraphaelloArgument = Argument

enum Field: Equatable, Hashable {
    struct Argument: Equatable, Hashable {
        let name: String
        let value: GraphaelloArgument
        let queryArgumentName: String
    }

    case direct(Schema.GraphQLType.Field)
    case call(Schema.GraphQLType.Field, [Argument])
}

extension Field.Argument {

    init(name: String, value: GraphaelloArgument) {
        self.init(name: name, value: value, queryArgumentName: name)
    }

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
                let type = field.arguments[element.name]?.type ?! fatalError("Missing Argument in field")
                switch element.value {

                case .value(let expression):
                    return GraphQLArgument(name: element.name,
                                           field: field,
                                           type: type,
                                           defaultValue: expression,
                                           argument: element.value)

                case .argument(.withDefault(let expression)):
                    return GraphQLArgument(name: element.name,
                                           field: field,
                                           type: type,
                                           defaultValue: expression,
                                           argument: element.value)

                case .argument(.forced):
                    return GraphQLArgument(name: element.name,
                                           field: field,
                                           type: type,
                                           defaultValue: nil,
                                           argument: element.value)
                }
            })
        }
    }

}
