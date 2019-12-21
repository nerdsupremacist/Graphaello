//
//  InitializerArgumentAssignmentFromQueryData.swift
//  Graphaello
//
//  Created by Mathias Quintero on 09.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

struct InitializerArgumentAssignmentFromQueryData: SwiftCodeTransformable {
    let name: String
    let expression: CodeTransformable
}

extension GraphQLStruct {
    
    var initializerArgumentAssignmentFromQueryData: [InitializerArgumentAssignmentFromQueryData] {
        let stockArguments = definition.properties
            .filter { $0.graphqlPath?.isConnection ?? true }
            .map { InitializerArgumentAssignmentFromQueryData(name: $0.name,
                                                              expression: $0.expression(in: self)) }
        
        let queryArgument = query != nil ? [InitializerArgumentAssignmentFromQueryData(name: "data", expression: "data")] : []
        let fragmentArguments = fragments.map { InitializerArgumentAssignmentFromQueryData(name: $0.target.name.camelized, expression: $0.target.name.camelized) }
        
        return stockArguments + queryArgument + fragmentArguments
    }
    
}

extension Property where CurrentStage == Stage.Resolved {

    fileprivate func expression(in graphQlStruct: GraphQLStruct) -> CodeTransformable {
        guard type != graphQlStruct.query?.api.name else { return "self" }
        guard let path = graphqlPath else { return name }
        guard case .some(.connection(let connectionFragment)) = path.referencedFragment else { fatalError() }
        let query = graphQlStruct.connectionQueries.first { $0.fragment.fragment.name == connectionFragment.fragment.name } ?! fatalError()
        return PagingFromFragment(path: path, query: query)
    }

}
