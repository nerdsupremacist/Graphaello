import Foundation
import SourceKittenFramework

protocol Pipeline {
    func extract(from file: File) throws -> [Struct<Stage.Extracted>]
    func parse(extracted: Struct<Stage.Extracted>) throws -> Struct<Stage.Parsed>
    func validate(parsed: Struct<Stage.Parsed>, using apis: [API]) throws -> Struct<Stage.Validated>
    func resolve(validated: [Struct<Stage.Validated>]) throws -> [Struct<Stage.Resolved>]
    func clean(resolved: [Struct<Stage.Resolved>]) throws -> [Struct<Stage.Cleaned>]
    
    func assemble(cleaned: Project.State<Stage.Cleaned>) throws -> Project.State<Stage.Assembled>
    
    func prepare(assembled: Project.State<Stage.Assembled>,
                 using apollo: ApolloReference) throws -> Project.State<Stage.Prepared>
    
    func generate(prepared: Project.State<Stage.Prepared>, useFormatting: Bool) throws -> String
}

extension Pipeline {
    
    func extract(from files: [File]) throws -> [Struct<Stage.Extracted>] {
        return try files.flatMap { try extract(from: $0) }
    }
    
    func parse(extracted: [Struct<Stage.Extracted>]) throws -> [Struct<Stage.Parsed>] {
        return try extracted.map { try parse(extracted: $0) }
    }
    
    func validate(parsed: [Struct<Stage.Parsed>], using apis: [API]) throws -> [Struct<Stage.Validated>] {
        return try parsed.map { try validate(parsed: $0, using: apis) }
    }
    
}
