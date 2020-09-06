import Foundation

struct InitializerArgumentAssignmentFromQueryData: SwiftCodeTransformable {
    let name: String
    let expression: CodeTransformable
}

extension Struct where CurrentStage == Stage.Prepared {
    
    var initializerArgumentAssignmentFromQueryData: [InitializerArgumentAssignmentFromQueryData] {
        let stockArguments = properties
            .filter { $0.graphqlPath?.resolved.isConnection ?? true }
            .filter { property in
                guard case .concrete = property.type else { return false }
                return true
            }
            .map { InitializerArgumentAssignmentFromQueryData(name: $0.name,
                                                              expression: $0.expression(in: self)) }
        
        let extraAPIArguments = additionalReferencedAPIs
            .filter { $0.property == nil }
            .map { InitializerArgumentAssignmentFromQueryData(name: $0.api.name.camelized,
                                                              expression: $0.expression(in: self)) }
        
        let queryArgument = query != nil ? [InitializerArgumentAssignmentFromQueryData(name: "data", expression: "data")] : []
        let fragmentArguments = fragments.map { InitializerArgumentAssignmentFromQueryData(name: $0.target.name.camelized, expression: $0.target.name.camelized) }
        
        return stockArguments + extraAPIArguments + queryArgument + fragmentArguments
    }
    
}

extension Property where CurrentStage == Stage.Prepared {

    fileprivate func expression(in graphQlStruct: Struct<Stage.Prepared>) -> CodeTransformable {
        guard let path = graphqlPath else {
            if case .concrete(let type) = type, type == graphQlStruct.query?.api.name {
                return "self"
            }
            return name
        }
        guard case .some(.connection(let connectionFragment)) = path.resolved.referencedFragment else {
            fatalError("Invalid State: should not attempt to get an expression from a regular GraphQL Value. Only from connections.")
        }
        let query = graphQlStruct
            .connectionQueries
            .first { $0.fragment.fragment.name == connectionFragment.fragment.name && $0.propertyName == name } ?!
                fatalError("Invalid State: Query containing the connection fragment doesn't exist")
        
        return PagingFromFragment(path: path, query: query)
    }

}

extension AdditionalReferencedAPI {
    
    fileprivate func expression(in graphQlStruct: Struct<Stage.Prepared>) -> CodeTransformable {
        guard api != graphQlStruct.query?.api else { return "self" }
        return api.name.camelized
    }
    
}
