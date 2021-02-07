import Foundation

protocol AliasStateMatcher {
    func match(query: GraphQLQuery, to aliased: GraphQLQuery) -> GraphQLQuery
}
