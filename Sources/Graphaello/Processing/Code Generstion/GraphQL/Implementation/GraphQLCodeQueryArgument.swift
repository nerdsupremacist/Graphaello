//
//  GraphQLCodeQueryArgument.swift
//  Graphaello
//
//  Created by Mathias Quintero on 11.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import Stencil

struct GraphQLCodeQueryArgument: ExtraValuesGraphQLCodeTransformable {
    let name: String
    let type: Schema.GraphQLType.Field.TypeReference

    func arguments(from context: Context, arguments: [Any?]) throws -> [String : Any] {
        return ["type": type.graphQLType]
    }
}

extension GraphQLQuery {
    
    var graphQLCodeQueryArgument: [GraphQLCodeQueryArgument] {
        return arguments.map { GraphQLCodeQueryArgument(name: $0.name, type: $0.type) }
    }
    
}

extension Field {
    
    fileprivate var graphQLCodeQueryArgument: [GraphQLCodeQueryArgument] {
        switch self {
        case .direct:
            return []
        case .call(let field, let arguments):
            let dictionary = Dictionary(uniqueKeysWithValues: field.arguments.map { ($0.name, $0.type) })
            return arguments.compactMap { element in
                guard let type = dictionary[element.name] else { return nil }
                return GraphQLCodeQueryArgument(name: element.name, type: type)
            }
        }
    }
    
}
