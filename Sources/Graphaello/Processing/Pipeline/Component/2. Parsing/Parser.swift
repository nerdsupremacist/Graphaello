import Foundation

protocol Parser {
    func parse(extracted: Struct<Stage.Extracted>) throws -> Struct<Stage.Parsed>
}
