//
//  QueryRendererArgument.swift
//  Graphaello
//
//  Created by Mathias Quintero on 09.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SwiftSyntax

struct QueryRendererArgument: SwiftCodeTransformable {
    let name: String
    let type: String
    let expression: ExprSyntax?
}

extension GraphQLStruct {
    
    var queryRendererArguments: [QueryRendererArgument] {
        let api = query?.api.name
        let argumentsFromStruct = definition.properties.compactMap { $0.directArgument }.filter { $0.type != api }
        let argumentsFromQuery = query?.arguments ?? []
        return argumentsFromQuery + argumentsFromStruct
    }
    
}

extension Property where CurrentStage: GraphQLStage {
    
    fileprivate var directArgument: QueryRendererArgument? {
        guard graphqlPath == nil else { return nil }
        return QueryRendererArgument(name: name, type: type, expression: nil)
    }
    
}

extension GraphQLQuery {
    
    fileprivate var arguments: [QueryRendererArgument] {
        return components.keys.flatMap { $0.arguments(api: api) }
    }
    
}

extension Field {
    
    fileprivate func arguments(api: API) -> [QueryRendererArgument] {
        switch self {
        case .direct:
            return []
        case .call(let field, let arguments):
            let dictionary = Dictionary(uniqueKeysWithValues: field.arguments.map { ($0.name, $0.type) })
            return arguments.compactMap { element in
                guard let queryArgument = element.value.queryArgument else { return nil }
                let type = dictionary[element.key]
                return QueryRendererArgument(name: element.key,
                                             type: type?.swiftType(api: api.name) ?? "Any",
                                             expression: queryArgument.expression)
            }
        }
    }
    
}

extension Argument {
    
    fileprivate var queryArgument: Argument.QueryArgument? {
        switch self {
        case .argument(let queryArgument):
            return queryArgument
        case .value:
            return nil
        }
    }
    
}

extension Argument.QueryArgument {
    
    fileprivate var expression: ExprSyntax? {
        switch self {
        case .forced:
            return nil
        case .withDefault(let expression):
            return expression
        }
    }
    
}
