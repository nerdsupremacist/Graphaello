import Foundation
import SwiftSyntax

struct PathResolver: ValueResolver {
    
    func resolve(value: Stage.Validated.Path,
                 in property: Property<Stage.Validated>,
                 using context: StructResolution.Context) throws -> StructResolution.Result<Stage.Resolved.Path> {
        
        guard value.components.last?.parsed == .fragment else {
            return .resolved(.init(validated: value, referencedFragment: nil))
        }
        
        if case .mutation = value.parsed.target {
            let fragmentName = try StructResolution.ReferencedMutationResultFragment(typeName: property.type).fragmentName
            guard let fragment = context[fragmentName] else { return .missingFragment }
            return .resolved(Stage.Resolved.Path(validated: value, referencedFragment: .mutationResult(fragment)))
        }
        
        switch try StructResolution.ReferencedFragment(typeName: property.type) {

        case .name(let fragmentName):
            guard let fragment = context[fragmentName] else { return .missingFragment }
            return .resolved(Stage.Resolved.Path(validated: value, referencedFragment: .fragment(fragment)))

        case .paging(let nodeFragmentName):
            guard let connectionType = value.components.last?.underlyingType else { fatalError() }
            guard let nodeFragment = context[nodeFragmentName] else { return .missingFragment }
            let fragment = try GraphQLConnectionFragment(connection: connectionType, nodeFragment: nodeFragment)
            return .resolved(Stage.Resolved.Path(validated: value, referencedFragment: .connection(fragment)))

        }
    }
    
}
