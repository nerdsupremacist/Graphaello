import Foundation
import Stencil

extension GraphQLFragment: ExtraValuesGraphQLCodeTransformable {

    func arguments(from context: Stencil.Context, arguments: [Any?]) throws -> [String : Any] {
        return ["isInsideFragment": true]
    }

}
