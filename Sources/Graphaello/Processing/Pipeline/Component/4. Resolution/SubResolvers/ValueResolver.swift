import Foundation

protocol ValueResolver {
    associatedtype Parent
    associatedtype Value
    associatedtype Resolved
    
    func resolve(value: Value,
                 in parent: Parent,
                 using context: StructResolution.Context) throws -> StructResolution.Result<Resolved>
}
