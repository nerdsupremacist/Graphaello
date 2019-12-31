//
//  BasicParser.swift
//  Graphaello
//
//  Created by Mathias Quintero on 12/8/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

struct BasicParser: Parser {
    let parser: SubParser<Stage.Extracted.Attribute, Stage.Parsed.Path?>

    func parse(extracted: Struct<Stage.Extracted>) throws -> Struct<Stage.Parsed> {
        return try extracted.map { property in
            return try property.with {
                try .parsed ~> property.attributes
                    .compactMap { attribute in
                        try parser.parse(from: attribute)
                    }
                    .first
            }
                
        }
    }
}

extension BasicParser {
    
    init(parser: () -> SubParser<Stage.Extracted.Attribute, Stage.Parsed.Path?>) {
        self.parser = parser()
    }
    
}
