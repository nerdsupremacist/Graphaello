//
//  InitializerArgumentAssignmentFromQueryData.swift
//  Graphaello
//
//  Created by Mathias Quintero on 09.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

struct InitializerArgumentAssignmentFromQueryData: SwiftCodeTransformable {
    let name: String
    let expression: String
}

extension GraphQLStruct {
    
    var initializerArgumentAssignmentFromQueryData: [InitializerArgumentAssignmentFromQueryData] {
        let api = query?.api.name
        
        let stockArguments = definition.properties
            .filter { $0.graphqlPath == nil }
            .map { InitializerArgumentAssignmentFromQueryData(name: $0.name,
                                                              expression: $0.type == api ? "self" : $0.name) }
        
        let queryArgument = query != nil ? [InitializerArgumentAssignmentFromQueryData(name: "data", expression: "data")] : []
        let fragmentArguments = fragments.map { InitializerArgumentAssignmentFromQueryData(name: $0.target.name.camelized, expression: $0.target.name.camelized) }
        
        return stockArguments + queryArgument + fragmentArguments
    }
    
}
