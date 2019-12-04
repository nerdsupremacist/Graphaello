//
//  Project+State.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 04.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import XcodeProj

extension XcodeProj {
    
    func state(sourcesPath: String) throws -> ProjectState {
        let apis = try scanAPIs(sourcesPath: sourcesPath)
        let structs = try scanStructs(sourcesPath: sourcesPath).filter { $0.hasGraphQLValues }
        return ProjectState(apis: apis, structs: structs)
    }
    
}
