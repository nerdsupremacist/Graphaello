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
            "queryArgumentAssignments": Array(query.queryArgumentAssignments)
        ]
    }

}

struct PlaceholderPagingFromFragment {
    let path: Stage.Cleaned.Path
    let query: GraphQLQuery
}

extension PlaceholderPagingFromFragment: ExtraValuesSwiftCodeTransformable {

    func arguments(from context: Stencil.Context, arguments: [Any?]) throws -> [String : Any] {
        return [
            "pathExpression": path.placeHolderExpression(),
            "optionalPathExpression": path.expression(queryValueIsOptional: true),
        ]
    }

}
