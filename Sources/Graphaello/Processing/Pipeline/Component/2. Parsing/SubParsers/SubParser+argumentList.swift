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
    
    static func argumentList(parser: @escaping () -> SubParser<ExprSyntax, Argument>) -> SubParser<FunctionCallArgumentListSyntax, [Field.Argument]> {
        return .init { arguments in
            let parser = parser()
            return try arguments.map { Field.Argument(name: $0.label?.text ?! fatalError(),
                                                      value: try parser.parse(from: $0.expression)) }
        }
    }
    
}
