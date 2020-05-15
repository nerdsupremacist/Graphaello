import Foundation

protocol AttributeExtractor {
    func extract(code: SourceCode) throws -> Stage.Extracted.Attribute
}
