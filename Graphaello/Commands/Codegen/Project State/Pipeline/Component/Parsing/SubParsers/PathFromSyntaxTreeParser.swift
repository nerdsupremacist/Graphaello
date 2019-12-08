//
//  PathFromSyntaxTreeParser.swift
//  Graphaello
//
//  Created by Mathias Quintero on 12/8/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SwiftSyntax

struct PathFromSyntaxTreeParser<Parser: SubParser>: SubParser where Parser.Input == FunctionCallExprSyntax, Parser.Output == Stage.Parsed.Path? {
    let parser: Parser

    func parse(from syntax: SourceFileSyntax) throws -> Stage.Parsed.Path? {
        guard let functionCall = syntax.singleItem() as? FunctionCallExprSyntax else { return nil }
        return try parser.parse(from: functionCall)
    }

}
