import Foundation

protocol Cleaner {
    func clean(resolved: [Struct<Stage.Resolved>]) throws -> [Struct<Stage.Cleaned>]
}
