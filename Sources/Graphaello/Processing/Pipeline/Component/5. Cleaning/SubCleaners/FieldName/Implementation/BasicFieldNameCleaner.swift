import Foundation

struct BasicFieldNameCleaner: FieldNameCleaner {
    let fragmentCleaner: AnyFieldNameCleaner<GraphQLFragment>
    let queryCleaner: AnyFieldNameCleaner<GraphQLQuery>
    let matcher: AliasStateMatcher
    
    func clean(resolved: Struct<Stage.Resolved>,
               using context: Cleaning.FieldName.Context) throws -> Cleaning.FieldName.Result<Struct<Stage.Resolved>> {
        
        let connectionFragments = try resolved
            .connectionQueries
            .map { $0.fragment.fragment }
            .collect(using: context) { try fragmentCleaner.clean(resolved: $0, using: $1) }
        
        let query = try queryCleaner.clean(resolved: resolved.query, using: connectionFragments)
        let fragments = try resolved.fragments.collect(using: query) { try fragmentCleaner.clean(resolved: $0, using: $1) }
        
        let connectionQueries = resolved.connectionQueries.map { (connectionQuery: GraphQLConnectionQuery) -> GraphQLConnectionQuery in
            let nodeFragment = fragments.context[connectionQuery.fragment.nodeFragment]
            let fragment = fragments.context[connectionQuery.fragment.fragment]
            let query = query.value.map { matcher.match(query: connectionQuery.query, to: $0) } ?? connectionQuery.query
            return GraphQLConnectionQuery(query: query,
                                          fragment: GraphQLConnectionFragment(connection: connectionQuery.fragment.connection,
                                                                              edgeType: connectionQuery.fragment.edgeType,
                                                                              nodeFragment: nodeFragment,
                                                                              fragment: fragment),
                                          propertyName: connectionQuery.propertyName)
        } as [GraphQLConnectionQuery]
        
        return fragments.map { fragments in
            resolved.with {
                .query ~> query.value;
                .fragments ~> fragments;
                .connectionQueries ~> connectionQueries;
            }
        }
    }
    
}


extension BasicFieldNameCleaner {
    
    init(objectCleaner: AnyFieldNameCleaner<GraphQLObject>,
         fragmentCleaner: (AnyFieldNameCleaner<GraphQLObject>) -> AnyFieldNameCleaner<GraphQLFragment>,
         queryCleaner: (AnyFieldNameCleaner<GraphQLObject>) -> AnyFieldNameCleaner<GraphQLQuery>,
         matcher: AliasStateMatcher) {
        
        self.init(fragmentCleaner: fragmentCleaner(objectCleaner),
                  queryCleaner: queryCleaner(objectCleaner),
                  matcher: matcher)
    }
    
}
