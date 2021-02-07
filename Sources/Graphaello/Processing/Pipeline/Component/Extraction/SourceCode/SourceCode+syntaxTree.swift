import Foundation
import SwiftSyntax

extension SourceCode {

    func syntaxTree() throws -> SourceFileSyntax {
        return try SyntaxParser.parse(source: content)
    }

}
