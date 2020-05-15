import Foundation
import SwiftSyntax

struct QueryRendererArgument: SwiftCodeTransformable {
    let name: String
    let type: String
    let expression: ExprSyntax?
}

extension Struct where CurrentStage: ResolvedStage {
    
    var queryRendererArguments: [QueryRendererArgument] {
        let api = query?.api.name
        let argumentsFromStruct = properties
            .compactMap { $0.directArgument }
            .filter { $0.type != api }
        
        let extraAPIArguments = additionalReferencedAPIs
            .filter { $0.property == nil }
            .filter { $0.api.name != api }
            .map { QueryRendererArgument(name: $0.api.name.camelized, type: $0.api.name, expression: nil) }

        let argumentsFromQuery = query?
            .arguments
            .filter { !$0.isHardCoded }
            .map { argument in
                return QueryRendererArgument(name: argument.name.camelized,
                                             type: argument.type.swiftType(api: api),
                                             expression: argument.defaultValue)
            } ?? []

        return argumentsFromQuery + argumentsFromStruct + extraAPIArguments
    }
    
}

extension GraphQLMutation {
    
    var queryRendererArguments: [QueryRendererArgument] {
        return arguments
            .filter { !$0.isHardCoded }
            .map { argument in
                return QueryRendererArgument(name: argument.name.camelized,
                                             type: argument.type.swiftType(api: api.name),
                                             expression: argument.defaultValue)
            }
    }
    
}

extension Property where CurrentStage: GraphQLStage {
    
    fileprivate var directArgument: QueryRendererArgument? {
        guard graphqlPath == nil else { return nil }
        return QueryRendererArgument(name: name,
                                     type: type.contains("->") ? "@escaping \(type)" : type,
                                     expression: nil)
    }
    
}
