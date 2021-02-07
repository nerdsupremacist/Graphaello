import Foundation

protocol ResolvedStructCollector {
    func collect(from properties: [Property<Stage.Resolved>],
                 for validated: Struct<Stage.Validated>) throws -> StructResolution.Result<Struct<Stage.Resolved>>
}
