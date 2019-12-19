//
//  QueryArgumentAssignment.swift
//  Graphaello
//
//  Created by Mathias Quintero on 09.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SwiftSyntax

struct QueryArgumentAssignment: SwiftCodeTransformable {
    let name: String
    let expression: ExprSyntax
}

extension GraphQLStruct {
    
    var queryArgumentAssignments: [QueryArgumentAssignment] {
        return query?.queryArgumentAssignments ?? []
    }
    
}

extension GraphQLQuery {
    
    fileprivate var queryArgumentAssignments: [QueryArgumentAssignment] {
        return arguments.map { QueryArgumentAssignment(name: $0.name,
                                                       expression: $0.assignmentExpression) }
    }
    
}

extension GraphQLArgument {

    var assignmentExpression: ExprSyntax {
        if case .value(let expression) = argument {
            return expression
        }

        if type.isScalar {
            return IdentifierExprSyntax(identifier: name.camelized)
        } else {
            return FunctionCallExprSyntax(target: MemberAccessExprSyntax(base: IdentifierExprSyntax(identifier: "ApolloStuff"),
                                                                         name: type.underlyingTypeName),
                                          arguments: [(nil, IdentifierExprSyntax(identifier: name.camelized))])
        }
    }

}
