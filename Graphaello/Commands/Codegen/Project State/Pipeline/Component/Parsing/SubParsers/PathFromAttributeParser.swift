//
//  PathFromAttributeParser.swift
//  Graphaello
//
//  Created by Mathias Quintero on 12/8/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SwiftSyntax

struct PathFromAttributeParser<Parser: SubParser>: SubParser where Parser.Input == SourceFileSyntax, Parser.Output == Stage.Parsed.Path? {
    let parser: Parser

    func parse(from attribute: Stage.Extracted.Attribute) throws -> Stage.Parsed.Path? {
        guard attribute.kind == ._custom else { return nil }
        let content = attribute.code.content

        let code = try SourceCode.singleExpression(content: String(content.dropFirst()))
        guard try code.kind() == .functionCall else { return nil }

        return try parser.parse(from: try code.syntaxTree())
    }
}
