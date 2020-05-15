import Foundation
import Stencil
import SwiftSyntax

struct QueryArgumentAssignment {
    let name: String
    let expression: ExprSyntax
}

extension QueryArgumentAssignment: ExtraValuesSwiftCodeTransformable {

    func arguments(from context: Stencil.Context, arguments: [Any?]) throws -> [String : Any] {
        return ["expression" : expression.description]
    }

}

extension Struct where CurrentStage: ResolvedStage {
    
    var queryArgumentAssignments: [QueryArgumentAssignment] {
        return query?.queryArgumentAssignments ?? []
    }
    
}

extension GraphQLQuery {
    
    var queryArgumentAssignments: [QueryArgumentAssignment] {
        return arguments.map { QueryArgumentAssignment(name: $0.name,
                                                       expression: $0.assignmentExpression) }
    }
    
}

extension GraphQLConnectionQuery {

    var queryArgumentAssignments: [QueryArgumentAssignment] {
        return query.queryArgumentAssignments.map { assignment in
            if assignment.name == "first" {
                let expression = SequenceExprSyntax(lhs: IdentifierExprSyntax(identifier: "_pageSize").erased(),
                                                    rhs: assignment.expression,
                                                    binaryOperator: BinaryOperatorExprSyntax(text: "??"))
                
                return QueryArgumentAssignment(name: assignment.name,
                                               expression: expression.erased())
            }
            if assignment.name == "after" {
                return QueryArgumentAssignment(name: assignment.name,
                                               expression: IdentifierExprSyntax(identifier: "_cursor").erased())
            }
            return assignment
        }
    }

}

extension GraphQLMutation {
    
    var queryArgumentAssignments: [QueryArgumentAssignment] {
        return arguments.map { QueryArgumentAssignment(name: $0.name,
                                                       expression: $0.assignmentExpression) }
    }
    
}

extension GraphQLArgument {

    var assignmentExpression: ExprSyntax {
        if case .value(let expression) = argument {
            return expression
        }
        
        return IdentifierExprSyntax(identifier: name.camelized).erased()
    }

}
