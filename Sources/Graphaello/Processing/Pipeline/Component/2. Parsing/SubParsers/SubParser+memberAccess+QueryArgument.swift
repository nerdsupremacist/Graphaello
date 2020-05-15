import Foundation
import SwiftSyntax

extension SubParser {
    
    static func memberAccess() -> SubParser<MemberAccessExprSyntax, Argument.QueryArgument> {
        return .init { expression in
            if expression.name.text == "forced" {
                return .forced
            } else {
                return .withDefault(expression.erased())
            }
        }
    }
    
}
