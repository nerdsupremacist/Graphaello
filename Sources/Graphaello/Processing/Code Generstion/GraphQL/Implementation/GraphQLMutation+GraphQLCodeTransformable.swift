import Foundation
import Stencil

extension GraphQLMutation: ExtraValuesGraphQLCodeTransformable {

    func arguments(from context: Stencil.Context, arguments: [Any?]) throws -> [String : Any] {
        return ["graphQLCodeQueryArgument" : graphQLCodeQueryArgument]
    }

}
