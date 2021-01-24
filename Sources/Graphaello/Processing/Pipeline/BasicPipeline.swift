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
    var diagnoser: WarningDiagnoser? = nil
    
    func extract(from file: WithTargets<File>) throws -> [Struct<Stage.Extracted>] {
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
    
    func generate(prepared: Project.State<Stage.Prepared>, useFormatting: Bool) throws -> String {
        return try generator.generate(prepared: prepared, useFormatting: useFormatting)
    }

    func diagnose(parsed: Struct<Stage.Parsed>) throws -> [Warning] {
        return try diagnoser?.diagnose(parsed: parsed) ?? []
    }
}
