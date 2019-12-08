//
//  AnyParser.swift
//  Graphaello
//
//  Created by Mathias Quintero on 12/8/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

extension SubParser {

    func eraseType() -> AnyParser<Input, Output> {
        return AnyParser(parser: self)
    }

}

class AnyParser<Input, Output>: SubParser {
    private let _parse: (Input) throws -> Output

    fileprivate init<P: SubParser>(parser: P) where P.Input == Input, P.Output == Output {
        _parse = parser.parse
    }

    func parse(from input: Input) throws -> Output {
        return try _parse(input)
    }
}
