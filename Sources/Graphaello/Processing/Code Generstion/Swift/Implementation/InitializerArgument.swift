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

extension Struct where CurrentStage == Stage.Prepared {
    
    var initializerArguments: [InitializerArgument] {
        let stockArguments = properties
            .filter { $0.graphqlPath?.resolved.isConnection ?? true }
            .map { InitializerArgument(name: $0.name, type: $0.type) }
        
        let queryArgument = query != nil ? [InitializerArgument(name: "data", type: "Data")] : []
        let fragmentArguments = fragments.map { InitializerArgument(name: $0.target.name.camelized, type: $0.target.name) }
        
        return stockArguments + queryArgument + fragmentArguments
    }
    
}
