import Foundation
import Stencil

struct AnyCodeTransformable: CodeTransformable {
    let _code: (Stencil.Context, [Any?]) throws -> String
    
    init(transformable: CodeTransformable) {
        _code = transformable.code
    }
    
    func code(using context: Stencil.Context, arguments: [Any?]) throws -> String {
        return try _code(context, arguments)
    }
}
