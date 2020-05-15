import Foundation

protocol PropertyAliasingPropagator {
    func propagate(property: Property<Stage.Resolved>, from resolved: Struct<Stage.Resolved>) throws -> Property<Stage.Cleaned>
}
