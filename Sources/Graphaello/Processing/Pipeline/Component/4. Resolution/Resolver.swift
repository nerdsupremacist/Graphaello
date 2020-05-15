import Foundation

protocol Resolver {
    func resolve(validated: [Struct<Stage.Validated>]) throws -> [Struct<Stage.Resolved>]
}
