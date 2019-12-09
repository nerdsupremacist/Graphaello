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
        return components.keys.flatMap { $0.queryArgumentAssignments }
    }
    
}

extension Field {
    
    fileprivate var queryArgumentAssignments: [QueryArgumentAssignment] {
        switch self {
        case .direct:
            return []
        case .call(_, let arguments):
            return arguments.map { element in
                return QueryArgumentAssignment(name: element.key,
                                               expression: element.value.expresion(name: element.key))
            }
        }
    }
    
}

extension Argument {
    
    fileprivate func expresion(name: String) -> ExprSyntax {
        switch self {
            
        case .value(let expression):
            return expression
        
        case .argument(.forced):
            let identifier = SyntaxFactory.makeIdentifier(name)
            return IdentifierExprSyntax { builder in
                builder.useIdentifier(identifier)
            }
        
        case .argument(.withDefault(let expression)):
            return expression
        
        }
    }
    
}
