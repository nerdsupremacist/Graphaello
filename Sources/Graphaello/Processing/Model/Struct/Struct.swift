//
//  Struct.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 12/1/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

struct Struct<CurrentStage: StageProtocol> {
    let code: SourceCode
    let name: String
    let properties: [Property<CurrentStage>]
    let context: Context
    
    init(code: SourceCode, name: String, properties: [Property<CurrentStage>]) {
        self.code = code
        self.name = name
        self.properties = properties
        self.context = .empty
    }
    
    init(code: SourceCode, name: String, properties: [Property<CurrentStage>], @ContextBuilder context: () throws -> ContextProtocol) rethrows {
        self.code = code
        self.name = name
        self.properties = properties
        self.context = try Context(context: context)
    }
}

extension Struct {
    
    func map<Stage: StageProtocol>(_ transform: (Property<CurrentStage>) throws -> Property<Stage>) rethrows -> Struct<Stage> {
        return Struct<Stage>(code: code, name: name, properties: try properties.map { try transform($0) })
    }

}

extension Struct {
    
    func with<Stage: StageProtocol>(properties: [Property<Stage>],
                                    @ContextBuilder context: () throws -> ContextProtocol) rethrows -> Struct<Stage> {
        
        return try Struct<Stage>(code: code, name: name, properties: properties) {
            self.context
            try context()
        }
    }
    
    func with(@ContextBuilder context: () throws -> ContextProtocol) rethrows -> Struct<CurrentStage> {
        return try with(properties: properties, context: context)
    }
    
}

extension Struct where CurrentStage: GraphQLStage {

    var hasGraphQLValues: Bool {
        return properties.contains { $0.graphqlPath != nil }
    }

}
