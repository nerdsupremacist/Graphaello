
import Foundation
import SwiftSyntax

extension ExprSyntax {

    func `as`(_: SyntaxEnum.Type) -> SyntaxEnum {
      return Syntax(self).as(SyntaxEnum.self)
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
