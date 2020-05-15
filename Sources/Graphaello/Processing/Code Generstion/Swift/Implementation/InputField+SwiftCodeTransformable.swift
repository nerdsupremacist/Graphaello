import Foundation
import Stencil

extension Schema.GraphQLType.InputField: ExtraValuesSwiftCodeTransformable {

    func arguments(from context: Stencil.Context, arguments: [Any?]) throws -> [String : Any] {
        let api = context["api"] as? API ?! fatalError("API Not found")
        return [
            "swiftType" : type.swiftType(api: api.name),
        ]
    }

}
