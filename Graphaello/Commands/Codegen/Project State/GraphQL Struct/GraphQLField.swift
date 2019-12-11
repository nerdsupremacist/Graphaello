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
