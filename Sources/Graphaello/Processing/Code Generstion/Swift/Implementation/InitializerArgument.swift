import Foundation

struct InitializerArgument: SwiftCodeTransformable {
    let name: String
    let type: String
}

extension Struct where CurrentStage == Stage.Prepared {
    
    var initializerArguments: [InitializerArgument] {
        let stockArguments = properties
            .compactMap { property -> InitializerArgument? in
                if let path = property.graphqlPath, !path.resolved.isConnection {
                    return nil
                }
                
                guard case .concrete(let type) = property.type else { return nil }
                return InitializerArgument(name: property.name,
                                           type: type.contains("->") ? "@escaping \(type)" : type)
            }
        
        let extraAPIArguments = additionalReferencedAPIs.filter { $0.property == nil }.map { InitializerArgument(name: $0.api.name.camelized, type: $0.api.name) }
        
        let queryArgument = query != nil ? [InitializerArgument(name: "data", type: "Data")] : []
        let fragmentArguments = fragments.map { InitializerArgument(name: $0.target.name.camelized, type: $0.target.name.upperCamelized) }
        
        return stockArguments + extraAPIArguments + queryArgument + fragmentArguments
    }
    
}
