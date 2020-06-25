import Foundation
import Stencil

extension API : ExtraValuesSwiftCodeTransformable {
    func arguments(from context: Stencil.Context, arguments: [Any?]) throws -> [String : Any] {
        return [
            "unifiedMacroFlag" : unifiedMacroFlag,
        ]
    }
}
