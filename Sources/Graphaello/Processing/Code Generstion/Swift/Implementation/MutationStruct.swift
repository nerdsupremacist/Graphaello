import Foundation
import Stencil

struct MutationStruct: ExtraValuesSwiftCodeTransformable {
    let mutation: GraphQLMutation
    
    func arguments(from context: Stencil.Context, arguments: [Any?]) throws -> [String : Any] {
        return [
            "swiftUnderlyingType": mutation.returnType.swiftType(api: mutation.api.name),
            "swiftType": mutation.returnType.swiftType(api: mutation.api.name, for: mutation.referencedFragment),
            "queryRendererArguments": Array(mutation.queryRendererArguments),
            "queryArgumentAssignments": Array(mutation.queryArgumentAssignments),
            "expression": Stage.Cleaned.Path(resolved: mutation.path,
                                             components: mutation.path.validated.components.map { Stage.Cleaned.Component(validated: $0, alias: nil) }).expression()
        ]
    }
}

extension Struct where CurrentStage: ResolvedStage {

    var mutationStructs: [MutationStruct] {
        return mutations.map { MutationStruct(mutation: $0) }
    }

}
