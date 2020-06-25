import Foundation
import SourceKittenFramework

protocol Extractor {
    func extract(from file: FileWithTargets) throws -> [Struct<Stage.Extracted>]
}
