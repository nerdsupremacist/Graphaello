
import Foundation
import SwiftSyntax

extension ExprSyntax {

    func switchOver() -> SyntaxEnum {
        return _syntaxNode.as(SyntaxEnum.self)
    }

}

extension ExprSyntaxProtocol {

    func erased() -> ExprSyntax {
        return ExprSyntax(self)
    }

}

extension SyntaxProtocol {

    func erased() -> Syntax {
        return Syntax(self)
    }

}
