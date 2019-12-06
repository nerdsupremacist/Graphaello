//
//  InitializerArgument.swift
//  Graphaello
//
//  Created by Mathias Quintero on 06.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

struct InitializerArgument: SwiftCodeTransformable {
    let name: String
    let type: String
}

extension GraphQLStruct {
    
    var initializerArguments: [InitializerArgument] {
        let stockArguments = definition.properties
            .filter { $0.graphqlPath == nil }
            .map { InitializerArgument(name: $0.name, type: $0.type) }
        
        let queryArgument = query != nil ? [InitializerArgument(name: "data", type: "Data")] : []
        let fragmentArguments = fragments.map { InitializerArgument(name: $0.target.name.camelized, type: $0.target.name) }
        
        return stockArguments + queryArgument + fragmentArguments
    }
    
}
