//
//  ProjectState+validate.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 04.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

extension Project.State where Component == StandardComponent {
    
    func validated() throws -> Project.State<ValidatedComponent> {
        return Project.State(apis: apis,
                             structs: try structs.map { try $0.validated(apis: apis) })
    }
    
}

extension Struct where Component == StandardComponent {
    
    fileprivate func validated(apis: [API]) throws -> Struct<ValidatedComponent> {
        return .init(name: name,
                     properties: try properties.map { try $0.validated(apis: apis) })
    }
    
}

extension Property where Component == StandardComponent {
    
    fileprivate func validated(apis: [API]) throws -> Property<ValidatedComponent> {
        return .init(name: name, type: type, graphqlPath: try graphqlPath.map { try $0.validated(apis: apis) })
    }
    
}
