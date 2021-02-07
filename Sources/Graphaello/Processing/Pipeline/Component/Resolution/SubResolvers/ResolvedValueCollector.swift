import Foundation

protocol ResolvedValueCollector {
    associatedtype Resolved
    associatedtype Parent
    associatedtype Collected
    
    func collect(from value: Resolved, in parent: Parent) throws -> StructResolution.Result<Collected>
}
