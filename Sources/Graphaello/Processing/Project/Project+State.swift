import Foundation

extension Project {

    struct State<CurrentStage: StageProtocol> {
        let apis: [API]
        let structs: [Struct<CurrentStage>]
        let cache: PersistentCache<AnyHashable>?
        let context: Context
        
        init(apis: [API], structs: [Struct<CurrentStage>], cache: PersistentCache<AnyHashable>?) {
            self.apis = apis
            self.structs = structs
            self.cache = cache
            self.context = .empty
        }
        
        init(apis: [API],
             structs: [Struct<CurrentStage>],
             cache: PersistentCache<AnyHashable>?,
             @ContextBuilder context: () throws -> ContextProtocol) rethrows {
            
            self.apis = apis
            self.structs = structs
            self.cache = cache
            self.context = try Context(context: context)
        }
    }
    
}

extension Project.State where CurrentStage == Stage.Parsed {

    private struct HashableState: Hashable {
        struct HashableProperty: Hashable {
            let name: String
            let apiName: String
            let target: Target
            let components: [Stage.Parsed.Component]
        }

        struct HashableStruct: Hashable {
            let name: String
            let macroFlag: String
            let properties: [HashableProperty]
        }

        let apis: [API]
        let structs: [HashableStruct]
    }

    func hashable() -> AnyHashable {
        return AnyHashable(
            HashableState(
                apis: apis,
                structs: structs.map { parsed in
                    HashableState.HashableStruct(
                        name: parsed.name,
                        macroFlag: parsed.unifiedMacroFlag,
                        properties: parsed.properties.compactMap { property in
                            guard let path = property.graphqlPath else { return nil }
                            return HashableState.HashableProperty(
                                name: property.name,
                                apiName: path.apiName,
                                target: path.target,
                                components: path.components
                            )
                        }
                    )
                }
            )
        )
    }

}

extension Target {

    fileprivate var description: String {
        switch self {
        case .mutation:
            return "mutation"
        case .query:
            return "query"
        case .object(let object):
            return object
        }
    }

}

extension Project.State {

    func with(cache: PersistentCache<AnyHashable>) -> Project.State<CurrentStage> {
        return Project.State(apis: apis, structs: structs, cache: cache)
    }

    func with(cache: PersistentCache<AnyHashable>?) -> Project.State<CurrentStage> {
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
