import Foundation
import Stencil

extension Schema.GraphQLType: ExtraValuesSwiftCodeTransformable {

    func arguments(from context: Stencil.Context, arguments: [Any?]) throws -> [String : Any] {
        let transpiler = BasicGraphQLToSwiftTranspiler()
        let usedTypes = context["usedTypes"] as? Set<Schema.GraphQLType> ?! fatalError("Used Types information not found")
        let api = context["api"] as? API ?! fatalError("API Not found")
        return [
            "shouldBeTypealias": !kind.isFragment && usedTypes.contains(self),
            "needsInitializer": inputFields?.contains { $0.defaultValue != nil } ?? false,
            "hasEnumValues": enumValues.map { !$0.isEmpty } ?? false,
            "inputFieldInitializerArguments": try inputFieldInitializerArguments(using: transpiler, in: api),
            "connectionNodeType": try connectionEdgeType(using: api)?.nodeField.type.nonNull.swiftType(api: api.name) ?? false,
        ]
    }

}
