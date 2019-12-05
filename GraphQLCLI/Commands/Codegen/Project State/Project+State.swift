//
//  Project+State.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 04.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

extension Project {
    
    func state() throws -> ProjectState {
        let apis = try scanAPIs()
        let structs = try scanStructs().filter { $0.hasGraphQLValues }
        return ProjectState(apis: apis, structs: structs)
    }
    
}
