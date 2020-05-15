import Foundation
import SwiftFormat
import Stencil

extension SwiftCodeTransformable {

    func withFormatting(format formatCode: Bool) -> FormattedSwiftCodeTransformable<Self> {
        return FormattedSwiftCodeTransformable(code: self, formatCode: formatCode)
    }

}

struct FormattedSwiftCodeTransformable<Code : SwiftCodeTransformable>: SwiftCodeTransformable {
    let code: Code
    let formatCode: Bool

    func code(using context: Stencil.Context, arguments: [Any?]) throws -> String {
        let code = try self.code.code(using: context, arguments: arguments)
        if formatCode {
            return try format(code)
        }
        return code
    }
}


extension FormattedSwiftCodeTransformable: Equatable where Code: Equatable { }

extension FormattedSwiftCodeTransformable: Hashable where Code: Hashable { }
