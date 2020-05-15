import Foundation
import Stencil

protocol GraphQLCodeTransformable: CodeTransformable {}

extension GraphQLCodeTransformable {
    
    func code(using context: Stencil.Context, arguments: [Any?]) throws -> String {
        let name = String(describing: Self.self)
        return try context.render(template: "graphQL/\(name).graphql.stencil",
                                  context: [name.replacingOccurrences(of: "GraphQL", with: "").camelized : self])
    }
    
}
