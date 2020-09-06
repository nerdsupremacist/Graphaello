import Foundation
import SwiftSyntax

struct InitializerValueAssignment: SwiftCodeTransformable {
    let name: String
    let expression: String
}

extension Struct where CurrentStage == Stage.Prepared {
    
    var initializerValueAssignments: [InitializerValueAssignment] {
        return properties.compactMap { property in
            switch property.graphqlPath {
            case .some(let path):
                let expression = path.initializerExpression(in: self) ?? property.name
                return InitializerValueAssignment(name: property.name,
                                                  expression: "GraphQL(\(expression))")
            case .none:
                guard case .concrete = property.type else { return nil }
                return InitializerValueAssignment(name: property.name, expression: property.name)
            }
        }
    }
    
}

extension Stage.Cleaned.Path {

    func initializerExpression<Stage: ResolvedStage>(in parent: Struct<Stage>) -> String? {
        if resolved.isMutation {
            let referencedAPI = parent.additionalReferencedAPIs.first { $0.api == resolved.validated.api } ?! fatalError()
            let name = referencedAPI.property?.name ?? referencedAPI.api.name.camelized
            return ".init(api: \(name))"
        }

        if resolved.isConnection {
            return nil
        }

        return expression()
    }

}
