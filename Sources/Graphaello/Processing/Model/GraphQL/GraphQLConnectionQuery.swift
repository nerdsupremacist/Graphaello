import Foundation

struct GraphQLConnectionQuery: Hashable {
    let query: GraphQLQuery
    let fragment: GraphQLConnectionFragment
    let propertyName: String
}
