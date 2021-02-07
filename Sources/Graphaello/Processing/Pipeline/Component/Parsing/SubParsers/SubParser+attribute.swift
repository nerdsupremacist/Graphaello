import Foundation
import SwiftSyntax

extension SubParser {
    
    static func attribute(parser: @escaping (Stage.Extracted.Attribute) -> SubParser<SourceFileSyntax, Stage.Parsed.Path?>) -> SubParser<Stage.Extracted.Attribute, Stage.Parsed.Path?> {
        return .init { attribute in
            guard attribute.kind == ._custom else { return nil }
            let content = attribute.code.content

            let code = try SyntaxParser.parse(source: String(content.dropFirst()))
            return try parser(attribute).parse(from: code)
        }
    }
    
}
