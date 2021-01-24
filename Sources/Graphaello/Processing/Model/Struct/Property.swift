import Foundation

enum PropertyType: Hashable {
    case concrete(String)
    case inferred
}

struct Property<CurrentStage: StageProtocol> {
    let code: SourceCode
    let name: String
    let type: PropertyType
    let context: Context
    
    init(code: SourceCode, name: String, type: PropertyType, @ContextBuilder context: () throws -> ContextProtocol) rethrows {
        self.code = code
        self.name = name
        self.type = type
        self.context = try Context(context: context)
    }
}

extension Property where CurrentStage: GraphQLStage {
    
    func map<Stage: GraphQLStage>(_ transform: (CurrentStage.Path) throws -> Stage.Path) rethrows -> Property<Stage> {
        return Property<Stage>(code: code, name: name, type: type, graphqlPath: try graphqlPath.map(transform))
    }
    
}

extension Property {
    
    func with<Stage: StageProtocol>(@ContextBuilder context: () throws -> ContextProtocol) rethrows -> Property<Stage> {
        return try Property<Stage>(code: code, name: name, type: type, context: context)
    }
    
}

extension Property where CurrentStage: GraphQLStage {
    
    func convert<Stage: GraphQLStage>() -> Property<Stage> where Stage.Path == CurrentStage.Path {
        return Property<Stage>(code: code, name: name, type: type, graphqlPath: graphqlPath)
    }
    
}
