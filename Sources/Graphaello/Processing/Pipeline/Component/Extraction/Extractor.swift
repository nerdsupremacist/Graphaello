import Foundation
import SourceKittenFramework

protocol Extractor {
    func extract(from file: WithTargets<File>) throws -> [Struct<Stage.Extracted>]
}
