import Foundation
import Stencil

extension GraphQLQuery: ExtraValuesGraphQLCodeTransformable {
    func arguments(from context: Stencil.Context, arguments: [Any?]) throws -> [String : Any] {
        return [
            "objectFieldCalls": objectFieldCalls,
            "graphQLCodeQueryArgument": Array(graphQLCodeQueryArgument),
        ]
    }
}
