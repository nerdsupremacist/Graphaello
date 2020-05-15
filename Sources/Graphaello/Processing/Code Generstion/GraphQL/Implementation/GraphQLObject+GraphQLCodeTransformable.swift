import Foundation
import Stencil

extension GraphQLObject: ExtraValuesGraphQLCodeTransformable {
    func arguments(from context: Stencil.Context, arguments: [Any?]) throws -> [String : Any] {
        return [
            "objectFieldCalls": objectFieldCalls,
            "referencedFragments": referencedFragments,
            "typeConditionals": typeConditionals.values.sorted { $0.type.name <= $1.type.name }
        ]
    }
}
