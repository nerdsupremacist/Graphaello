import Foundation

protocol PropertyExtractor {
    func extract(code: SourceCode) throws -> Property<Stage.Extracted>?
}
