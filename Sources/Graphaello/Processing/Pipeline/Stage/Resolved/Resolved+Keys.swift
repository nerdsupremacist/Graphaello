import Foundation

extension Context.Key where T == Stage.Resolved.Path? {
    
    static let resolved = Context.Key<Stage.Resolved.Path?>()
    
}

extension Context.Key where T == [GraphQLFragment] {
    
    static let fragments = Context.Key<[GraphQLFragment]>()
    
}

extension Context.Key where T == GraphQLQuery? {
    
    static let query = Context.Key<GraphQLQuery?>()
    
}

extension Context.Key where T == [GraphQLMutation] {

    static let mutations = Context.Key<[GraphQLMutation]>()

}

extension Context.Key where T == [GraphQLConnectionQuery] {
    
    static let connectionQueries = Context.Key<[GraphQLConnectionQuery]>()
    
}
