//
//  BasicParser.swift
//  Graphaello
//
//  Created by Mathias Quintero on 12/8/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

struct BasicParser<PathParser: SubParser>: Parser where PathParser.Input == Stage.Extracted.Attribute, PathParser.Output == Stage.Parsed.Path {
    let parser: PathParser

    func parse(extracted: Struct<Stage.Extracted>) throws -> Struct<Stage.Parsed> {
        return try extracted.map { attributes in
            return try attributes
                .compactMap { attribute in
                    try parser.parse(from: attribute)
                }
                .first
        }
    }
}
