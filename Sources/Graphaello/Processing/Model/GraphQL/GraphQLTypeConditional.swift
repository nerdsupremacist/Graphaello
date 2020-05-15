import Foundation

struct GraphQLTypeConditional: Hashable {
    let type: Schema.GraphQLType
    let object: GraphQLObject
}

extension GraphQLTypeConditional {

    var arguments: OrderedSet<GraphQLArgument> {
        return object.arguments
    }

}

extension GraphQLTypeConditional {

    static func + (lhs: GraphQLTypeConditional, rhs: GraphQLTypeConditional) -> GraphQLTypeConditional {
        assert(lhs.type.name == rhs.type.name)
        return GraphQLTypeConditional(type: lhs.type,
                                      object: lhs.object + rhs.object)
    }

}
