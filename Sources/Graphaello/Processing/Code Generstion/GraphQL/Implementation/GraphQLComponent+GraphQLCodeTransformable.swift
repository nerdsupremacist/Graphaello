import Foundation
import Stencil

extension GraphQLComponent: ExtraValuesGraphQLCodeTransformable {
    func arguments(from context: Stencil.Context, arguments: [Any?]) throws -> [String : Any] {
        return [
            "object": object ?? false,
        ]
    }
}

extension GraphQLComponent {
    
    fileprivate var object: GraphQLObject? {
        guard case .object(let object) = self else { return nil }
        return object
    }
    
}
