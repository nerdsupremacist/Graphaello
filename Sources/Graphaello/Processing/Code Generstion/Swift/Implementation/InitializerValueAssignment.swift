//
//  InitializerValueAssignment.swift
//  Graphaello
//
//  Created by Mathias Quintero on 06.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SwiftSyntax

struct InitializerValueAssignment: SwiftCodeTransformable {
    let name: String
    let expression: String
}

extension Struct where CurrentStage == Stage.Prepared {
    
    var initializerValueAssignments: [InitializerValueAssignment] {
        return properties.map { property in
            switch property.graphqlPath {
            case .some(let path):
                let expression = path.isConnection ? property.name : path.expression()
                return InitializerValueAssignment(name: property.name,
                                                  expression: "GraphQL(\(expression))")
            case .none:
                return InitializerValueAssignment(name: property.name, expression: property.name)
            }
        }
    }
    
}
