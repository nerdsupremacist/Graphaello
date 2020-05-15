import Foundation
import Stencil

protocol CodeTransformable {
    func code(using context: Stencil.Context, arguments: [Any?]) throws -> String
}

extension CodeTransformable {
    
    func code(using environment: Environment, context: [String : Any] = [:]) throws -> String {
        let context = context.merging(["value" : self]) { $1 }
        return try environment.renderTemplate(name: "CodeTransformable.stencil", context: context)
    }
    
}
