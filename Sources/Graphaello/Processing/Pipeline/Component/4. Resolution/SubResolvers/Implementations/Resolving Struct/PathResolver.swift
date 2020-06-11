import Foundation
import SwiftSyntax

struct PathResolver: ValueResolver {
    
    func resolve(value: Stage.Validated.Path,
                 in property: Property<Stage.Validated>,
                 using context: StructResolution.Context) throws -> StructResolution.Result<Stage.Resolved.Path> {
        
        guard value.components.last?.parsed == .fragment else {
            return .resolved(.init(validated: value, referencedFragment: nil, isReferencedFragmentASingleFragmentStruct: false))
        }
        
        if case .mutation = value.parsed.target {
            let fragmentName = try StructResolution.ReferencedMutationResultFragment(typeName: property.type).fragmentName
            guard let result = context[fragmentName] else { return .missingFragment }
            return .resolved(Stage.Resolved.Path(validated: value, referencedFragment: .mutationResult(result.fragment), isReferencedFragmentASingleFragmentStruct: result.isReferencedFragmentASingleFragmentStruct))
        }
        
        switch try StructResolution.ReferencedFragment(typeName: property.type) {

        case .name(let fragmentName):
            guard let result = context[fragmentName] else { return .missingFragment }
            return .resolved(Stage.Resolved.Path(validated: value, referencedFragment: .fragment(result.fragment), isReferencedFragmentASingleFragmentStruct: result.isReferencedFragmentASingleFragmentStruct))

        case .paging(let nodeFragmentName):
            guard let connectionType = value.components.last?.underlyingType else { fatalError() }
            guard let result = context[nodeFragmentName] else { return .missingFragment }
            let fragment = try GraphQLConnectionFragment(connection: connectionType, nodeFragment: result.fragment)
            return .resolved(Stage.Resolved.Path(validated: value, referencedFragment: .connection(fragment), isReferencedFragmentASingleFragmentStruct: result.isReferencedFragmentASingleFragmentStruct))

        }
    }
    
}
