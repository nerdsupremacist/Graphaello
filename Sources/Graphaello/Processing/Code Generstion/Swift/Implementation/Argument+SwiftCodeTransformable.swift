import Foundation
import Stencil

extension Schema.GraphQLType.Field.Argument: ExtraValuesSwiftCodeTransformable {
    
    func arguments(from context: Stencil.Context, arguments: [Any?]) throws -> [String : Any] {
        
        let api = context["api"] as? API ?! fatalError("API Not found")
        let swiftType = type.swiftType(api: api.name)
        
        return [
            "swiftType": swiftType
        ]
    }
    
}
