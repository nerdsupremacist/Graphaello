//
//  PathFromSyntaxTreeParser.swift
//  Graphaello
//
//  Created by Mathias Quintero on 12/8/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SwiftSyntax

extension SubParser {
    
    static func syntaxTree(parser: @escaping () -> SubParser<FunctionCallExprSyntax, Stage.Parsed.Path?>) -> SubParser<SourceFileSyntax, Stage.Parsed.Path?> {
        return .init { syntax in
            guard let functionCall = syntax.singleItem() as? FunctionCallExprSyntax else { return nil }
            return try parser().parse(from: functionCall)
        }
    }
    
}
