import Foundation

struct Struct<CurrentStage: StageProtocol> {
    let code: SourceCode
    let name: String
    let inheritedTypes: [String]
    let properties: [Property<CurrentStage>]
    let context: Context
    
    init(code: SourceCode, name: String, inheritedTypes: [String], properties: [Property<CurrentStage>]) {
        self.code = code
        self.name = name
        self.inheritedTypes = inheritedTypes
        self.properties = properties
        self.context = .empty
    }
    
    init(code: SourceCode, name: String, inheritedTypes: [String], properties: [Property<CurrentStage>], @ContextBuilder context: () throws -> ContextProtocol) rethrows {
        self.code = code
        self.name = name
        self.inheritedTypes = inheritedTypes
        self.properties = properties
        self.context = try Context(context: context)
    }
}

extension Struct {
    
    var macros: [String] {
        return code.targets.map { "GRAPHAELLO_\($0.snakeUpperCased)_TARGET" }
    }
    
    var unifiedMacroFlag: String {
        guard !code.targets.isEmpty else { return "0" }
        return macros.joined(separator: " || ")
    }
    
}

extension Struct {
    
    func map<Stage: StageProtocol>(_ transform: (Property<CurrentStage>) throws -> Property<Stage>) rethrows -> Struct<Stage> {
        return Struct<Stage>(code: code, name: name, inheritedTypes: inheritedTypes, properties: try properties.map { try transform($0) })
    }

}

extension Struct {
    func with<Stage: StageProtocol>(properties: [Property<Stage>]) -> Struct<Stage> {
        return Struct<Stage>(code: code, name: name, inheritedTypes: inheritedTypes, properties: properties) { context }
    }
    
    func with<Stage: StageProtocol>(properties: [Property<Stage>],
                                    @ContextBuilder context: () throws -> ContextProtocol) rethrows -> Struct<Stage> {
        
        return try Struct<Stage>(code: code, name: name, inheritedTypes: inheritedTypes, properties: properties) {
            self.context
            try context()
        }
    }
    
    func with(@ContextBuilder context: () throws -> ContextProtocol) rethrows -> Struct<CurrentStage> {
        return try with(properties: properties, context: context)
    }
    
}

extension Struct where CurrentStage: GraphQLStage {
    
    func with<Stage: GraphQLStage>(@ContextBuilder context: () throws -> ContextProtocol) rethrows -> Struct<Stage> where Stage.Path == CurrentStage.Path {
        return try with(properties: properties.map { $0.convert() }, context: context)
    }
    
    func convert<Stage: GraphQLStage>() -> Struct<Stage> where Stage.Path == CurrentStage.Path {
        return with { context }
    }
    
}

extension Struct where CurrentStage: GraphQLStage {

    var hasGraphQLValues: Bool {
        return properties.contains { $0.graphqlPath != nil }
    }

}
