import Foundation

struct GraphQLMutation {
    let api: API
    let target: Schema.GraphQLType
    let name: String
    let path: Stage.Resolved.Path
    let returnType: Schema.GraphQLType.Field.TypeReference
    let object: GraphQLObject
    let referencedFragment: GraphQLFragment?
}

extension GraphQLMutation {

    var arguments: OrderedSet<GraphQLArgument> {
        return object.arguments
    }

}
