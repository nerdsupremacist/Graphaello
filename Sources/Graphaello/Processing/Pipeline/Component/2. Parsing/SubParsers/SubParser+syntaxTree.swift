import Foundation
import SwiftSyntax

extension SubParser {
    
    static func syntaxTree(parser: @escaping () -> SubParser<FunctionCallExprSyntax, Stage.Parsed.Path?>) -> SubParser<SourceFileSyntax, Stage.Parsed.Path?> {
        return .init { syntax in
            guard let functionCall = syntax.singleItem()?.as(FunctionCallExprSyntax.self) else { return nil }
            return try parser().parse(from: functionCall)
        }
    }
    
}
