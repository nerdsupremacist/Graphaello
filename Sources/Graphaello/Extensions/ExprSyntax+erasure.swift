
import Foundation
import SwiftSyntax

extension ExprSyntax {

    func withoutErasure() -> ExprSyntaxProtocol {
        return asProtocol(ExprSyntaxProtocol.self)
    }

}

extension ExprSyntaxProtocol {

    func erased() -> ExprSyntax {
        return ExprSyntax(self)
    }

}
