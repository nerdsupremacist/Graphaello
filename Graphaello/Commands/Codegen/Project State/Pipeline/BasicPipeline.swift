//
//  BasicPipeline.swift
//  Graphaello
//
//  Created by Mathias Quintero on 12/8/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SourceKittenFramework

struct BasicPipeline: Pipeline {
    let extractor: Extractor
    let parser: Parser
    
    func extract(from file: File) throws -> [Struct<Stage.Extracted>] {
        return try extractor.extract(from: file)
    }
    
    func parse(extracted: Struct<Stage.Extracted>) throws -> Struct<Stage.Parsed> {
        return try parser.parse(extracted: extracted)
    }
    
    func validate(parsed: Struct<Stage.Parsed>, using apis: [API]) throws -> Struct<Stage.Validated> {
        fatalError()
    }
    
    func resolve(validated: [Struct<Stage.Validated>]) throws -> [GraphQLStruct] {
        fatalError()
    }
}
