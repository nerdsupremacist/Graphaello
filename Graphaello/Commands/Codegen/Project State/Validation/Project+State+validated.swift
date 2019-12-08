//
//  ProjectState+validate.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 04.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

extension Project.State where CurrentStage == Stage.Parsed {
    
    func validated() throws -> Project.State<Stage.Validated> {
        return Project.State(apis: apis,
                             structs: try structs.map { try $0.validated(apis: apis) })
    }
    
}

extension Struct where CurrentStage == Stage.Parsed {
    
    fileprivate func validated(apis: [API]) throws -> Struct<Stage.Validated> {
        return try map { try $0.map { try $0.validated(apis: apis) } }
    }
    
}
