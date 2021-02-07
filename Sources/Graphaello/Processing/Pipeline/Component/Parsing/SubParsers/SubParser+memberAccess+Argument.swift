import Foundation
import SwiftSyntax

extension SubParser {
    
    static func memberAccess() -> SubParser<MemberAccessExprSyntax, Argument> {
        return .init { member in
            guard member.name.text == "argument" else {
                throw ParseError.cannotInstantiateObjectFromExpression(member.erased(), type: Argument.self)
            }
            return .argument(.forced)
        }
    }
    
}
