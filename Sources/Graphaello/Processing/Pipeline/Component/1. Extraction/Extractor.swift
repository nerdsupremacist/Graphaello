import Foundation
import SourceKittenFramework

protocol Extractor {
    func extract(from file: File) throws -> [Struct<Stage.Extracted>]
}
