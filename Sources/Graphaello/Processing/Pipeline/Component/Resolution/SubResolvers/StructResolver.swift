import Foundation

protocol StructResolver {
    associatedtype Resolved
    
    func resolve(validated: Struct<Stage.Validated>,
                 using context: StructResolution.Context) throws -> StructResolution.Result<Resolved>
}
