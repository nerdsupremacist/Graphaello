//
//  Project+State.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 04.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

extension Project {

    struct State<CurrentStage: StageProtocol> {
        let apis: [API]
        let structs: [Struct<CurrentStage>]
        let cache: FileCache<AnyHashable>?
        let context: Context
        
        init(apis: [API], structs: [Struct<CurrentStage>], cache: FileCache<AnyHashable>?) {
            self.apis = apis
            self.structs = structs
            self.cache = cache
            self.context = .empty
        }
        
        init(apis: [API],
             structs: [Struct<CurrentStage>],
             cache: FileCache<AnyHashable>?,
             @ContextBuilder context: () throws -> ContextProtocol) rethrows {
            
            self.apis = apis
            self.structs = structs
            self.cache = cache
            self.context = try Context(context: context)
        }
    }
    
}

extension Project.State {

    func with(cache: FileCache<AnyHashable>) -> Project.State<CurrentStage> {
        return Project.State(apis: apis, structs: structs, cache: cache)
    }

    func with(cache: FileCache<AnyHashable>?) -> Project.State<CurrentStage> {
        guard let cache = cache else { return self }
        return with(cache: cache)
    }

}

extension Project.State where CurrentStage: GraphQLStage {

    var graphQLPaths: [CurrentStage.Path] {
        return structs.flatMap { $0.properties.compactMap { $0.graphqlPath } }
    }

}

extension Project.State {
    
    func with<Stage: StageProtocol>(structs: [Struct<Stage>],
                                    @ContextBuilder context: () throws -> ContextProtocol) rethrows -> Project.State<Stage> {
        
        return try Project.State(apis: apis, structs: structs, cache: cache) {
            self.context
            try context()
        }
    }
    
    func with<Stage: StageProtocol>(structs: [Struct<Stage>]) -> Project.State<Stage> {
        return Project.State(apis: apis, structs: structs, cache: cache) { self.context }
    }
    
}

extension Project.State where CurrentStage: GraphQLStage {
    
    func with<Stage: GraphQLStage>(@ContextBuilder context: () throws -> ContextProtocol) rethrows -> Project.State<Stage> where Stage.Path == CurrentStage.Path {
        return try with(structs: structs.map { $0.convert() }, context: context)
    }
    
    func convert<Stage: GraphQLStage>() -> Project.State<Stage> where Stage.Path == CurrentStage.Path {
        return with { context }
    }
    
}
