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
    let validator: Validator
    let resolver: Resolver
    let cleaner: Cleaner
    let assembler: Assembler
    let preparator: Preparator
    let generator: Generator
    
    func extract(from file: File) throws -> [Struct<Stage.Extracted>] {
        return try extractor.extract(from: file)
    }
    
    func parse(extracted: Struct<Stage.Extracted>) throws -> Struct<Stage.Parsed> {
        return try parser.parse(extracted: extracted)
    }
    
    func validate(parsed: Struct<Stage.Parsed>, using apis: [API]) throws -> Struct<Stage.Validated> {
        return try validator.validate(parsed: parsed, using: apis)
    }
    
    func resolve(validated: [Struct<Stage.Validated>]) throws -> [Struct<Stage.Resolved>] {
        return try resolver.resolve(validated: validated)
    }
    
    func clean(resolved: [Struct<Stage.Resolved>]) throws -> [Struct<Stage.Cleaned>] {
        return try cleaner.clean(resolved: resolved)
    }
    
    func assemble(cleaned: Project.State<Stage.Cleaned>) throws -> Project.State<Stage.Assembled> {
        return try assembler.assemble(cleaned: cleaned)
    }
    
    func prepare(assembled: Project.State<Stage.Assembled>,
                 using apollo: ApolloReference) throws -> Project.State<Stage.Prepared> {
        
        return try preparator.prepare(assembled: assembled, using: apollo)
    }
    
    func generate(prepared: Project.State<Stage.Prepared>) throws -> String {
        return try generator.generate(prepared: prepared)
    }
}
