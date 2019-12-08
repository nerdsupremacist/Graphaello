//
//  Project+State.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 04.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

extension Project {

    struct State<CurrentStage: GraphQLStage> {
        let apis: [API]
        let structs: [Struct<CurrentStage>]
    }

    func state() throws -> State<Stage.Parsed> {
        let apis = try scanAPIs()
        let structs = try scanStructs().filter { $0.hasGraphQLValues }
        return State(apis: apis, structs: structs)
    }
    
}
