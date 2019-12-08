//
//  PathFromAttributeParser.swift
//  Graphaello
//
//  Created by Mathias Quintero on 12/8/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SwiftSyntax

extension SubParser {
    
    static func attribute(parser: @escaping () -> SubParser<SourceFileSyntax, Stage.Parsed.Path?>) -> SubParser<Stage.Extracted.Attribute, Stage.Parsed.Path?> {
        return .init { attribute in
            guard attribute.kind == ._custom else { return nil }
            let content = attribute.code.content

            let code = try SourceCode.singleExpression(content: String(content.dropFirst()))
            guard try code.kind() == .functionCall else { return nil }

            return try parser().parse(from: try code.syntaxTree())
        }
    }
    
}
