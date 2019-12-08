//
//  ArgumentsFromArgumentListParser.swift
//  Graphaello
//
//  Created by Mathias Quintero on 12/8/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SwiftSyntax

extension SubParser {
    
    static func argumentList(parser: @escaping () -> SubParser<ExprSyntax, Argument>) -> SubParser<FunctionCallArgumentListSyntax, [String : Argument]> {
        return .init { arguments in
            let parser = parser()
            let baseDictionary = Dictionary(uniqueKeysWithValues: arguments.map { ($0.label?.text ?! fatalError(), $0) })
            return try baseDictionary.mapValues { try parser.parse(from: $0.expression) }
        }
    }
    
}
