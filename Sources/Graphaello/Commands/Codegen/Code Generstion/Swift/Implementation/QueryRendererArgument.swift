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
        let argumentsFromStruct = definition
            .properties
            .compactMap { $0.directArgument }
            .filter { $0.type != api }

        let argumentsFromQuery = query?
            .arguments
            .map { argument in
                return QueryRendererArgument(name: argument.name,
                                             type: argument.type.swiftType(api: api),
                                             expression: argument.defaultValue)
            } ?? []

        return argumentsFromQuery + argumentsFromStruct
    }
    
}

extension Property where CurrentStage: GraphQLStage {
    
    fileprivate var directArgument: QueryRendererArgument? {
        guard graphqlPath == nil else { return nil }
        return QueryRendererArgument(name: name, type: type, expression: nil)
    }
    
}
