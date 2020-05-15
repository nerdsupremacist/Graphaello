import Foundation
import Stencil

extension String: CodeTransformable {
    
    func code(using context: Stencil.Context, arguments: [Any?]) throws -> String {
        return self
    }
    
}
