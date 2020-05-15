import Foundation
import Stencil

extension Optional: CodeTransformable where Wrapped: CodeTransformable {
    func code(using context: Stencil.Context, arguments: [Any?]) throws -> String {
        return try self?.code(using: context, arguments: arguments) ?? ""
    }
}
