import Foundation
import Stencil

private let swiftUIViewProtocols: Set<String> = ["View"]

extension Struct: CodeTransformable where CurrentStage == Stage.Prepared { }

extension Struct: SwiftCodeTransformable where CurrentStage == Stage.Prepared { }

extension Struct: ExtraValuesSwiftCodeTransformable where CurrentStage == Stage.Prepared {
    
    func arguments(from context: Stencil.Context, arguments: [Any?]) throws -> [String : Any] {
        return [
            "functionName" : name.camelized,
            "fragments": fragments,
            "query": query ?? false,
            "initializerArguments" : initializerArguments,
            "initializerValueAssignments" : initializerValueAssignments,
            "placeHolderInitializerArguments" : placeHolderInitializerArguments,
            "placeholderInitializerValueAssignments" : placeholderInitializerValueAssignments,
            "queryRendererArguments": Array(queryRendererArguments),
            "queryArgumentAssignments": Array(queryArgumentAssignments),
            "initializerArgumentAssignmentFromQueryData": initializerArgumentAssignmentFromQueryData,
            "placeholderInitializerArgumentAssignmentFromQuery" : placeholderInitializerArgumentAssignmentFromQuery,
            "mutationStructs": mutationStructs,
            "queryDataPlaceholders": Array(queryDataPlaceholders),
            "fragmentPlaceholders": Array(fragmentPlaceholders),
            "missingFragmentsStructs": Array(missingFragmentsStructs),
            "missingReferencedFragments": Array(missingReferencedFragments),
            "singleFragment": singleFragment ?? false,
            "isSwiftUIView" : !swiftUIViewProtocols.intersection(inheritedTypes).isEmpty,
            "unifiedMacroFlag" : unifiedMacroFlag,
        ]
    }
    
}
