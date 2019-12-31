//
//  PagingFromFragment.swift
//  
//
//  Created by Mathias Quintero on 12/21/19.
//

import Foundation
import Stencil

struct PagingFromFragment {
    let path: Stage.Cleaned.Path
    let query: GraphQLConnectionQuery
}

extension PagingFromFragment: ExtraValuesSwiftCodeTransformable {

    func arguments(from context: Stencil.Context, arguments: [Any?]) throws -> [String : Any] {
        return [
            "pathExpression": path.expression(),
            "optionalPathExpression": path.expression(queryValueIsOptional: true),
            "queryArgumentAssignments": query.queryArgumentAssignments
        ]
    }

}
