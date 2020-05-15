import Foundation
import Stencil

extension GraphQLConnectionFragment: ExtraValuesSwiftCodeTransformable {

    func arguments(from context: Stencil.Context, arguments: [Any?]) throws -> [String : Any] {
        return [
            "missingFragmentsStructs": Array(missingFragmentsStructs),
            "missingReferencedFragments": Array(missingReferencedFragments),
        ]
    }

}
