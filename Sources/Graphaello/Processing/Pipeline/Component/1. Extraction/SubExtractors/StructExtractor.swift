import Foundation

protocol StructExtractor {
    func extract(code: SourceCode) throws -> Struct<Stage.Extracted>
}
