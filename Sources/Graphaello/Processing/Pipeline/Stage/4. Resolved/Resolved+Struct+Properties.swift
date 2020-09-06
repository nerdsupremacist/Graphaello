import Foundation

extension Struct where CurrentStage: ResolvedStage {
    var fragments: [GraphQLFragment] {
        return context[.fragments]
    }
    
    var query: GraphQLQuery? {
        return context[.query]
    }
    
    var connectionQueries: [GraphQLConnectionQuery] {
        return context[.connectionQueries]
    }

    var mutations: [GraphQLMutation] {
        return context[.mutations]
    }
    
    var additionalReferencedAPIs: OrderedSet<AdditionalReferencedAPI<CurrentStage>> {
        let types = Dictionary(
            properties
                .filter { $0.graphqlPath == nil }
                .compactMap { property -> (String, Property<CurrentStage>)? in
                    guard case .concrete(let type) = property.type else { return nil }
                    return (type, property)
                }
        ) { $1 }
        return OrderedSet(mutations.map { AdditionalReferencedAPI(api: $0.api, property: types[$0.api.name]) })
    }
    
    init(code: SourceCode,
         name: String,
         inheritedTypes: [String],
         properties: [Property<CurrentStage>],
         fragments: [GraphQLFragment],
         query: GraphQLQuery?,
         connectionQueries: [GraphQLConnectionQuery],
         mutations: [GraphQLMutation]) {
        
        self.init(code: code, name: name, inheritedTypes: inheritedTypes, properties: properties) {
            .fragments ~> fragments;
            .query ~> query;
            .connectionQueries ~> connectionQueries;
            .mutations ~> mutations;
        }
    }
    
}
