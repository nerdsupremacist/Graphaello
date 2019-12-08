//
//  ArgumentsFromArgumentListParser.swift
//  Graphaello
//
//  Created by Mathias Quintero on 12/8/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SwiftSyntax

struct ArgumentsFromArgumentListParser<Parser: SubParser>: SubParser where Parser.Input == ExprSyntax, Parser.Output == Argument {
    let parser: Parser

    func parse(from arguments: FunctionCallArgumentListSyntax) throws -> [String : Argument] {
        let baseDictionary = Dictionary(uniqueKeysWithValues: arguments.map { ($0.label?.text ?! fatalError(), $0) })
        return  try baseDictionary.mapValues { try parser.parse(from: $0.expression) }
    }
}
