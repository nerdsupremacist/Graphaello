import Foundation
import Stencil

extension Array: CodeTransformable where Element: CodeTransformable {
    
    func code(using context: Stencil.Context, arguments: [Any?]) throws -> String {
        return try context.render(template: "Array.stencil", context: ["values" : self])
    }
    
}

extension Array {
    
    func code(using context: Stencil.Context, arguments: [Any?]) throws -> [String] {
        return try compactMap { element in
            switch element {
            case let element as CodeTransformable:
                return try element.code(using: context, arguments: arguments)
            case let element as CustomStringConvertible:
                return element.description
            default:
                return nil
            }
        }
    }
    
}
