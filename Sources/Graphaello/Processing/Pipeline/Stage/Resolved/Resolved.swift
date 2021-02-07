import Foundation

extension Stage {

    // All GraphQL Fragments and Queries where Resolved
    enum Resolved: GraphQLStage, ResolvedStage {
        enum ReferencedFragment {
            case fragment(GraphQLFragment)
            case mutationResult(GraphQLFragment)
            case connection(GraphQLConnectionFragment)
        }

        struct Path {
            let validated: Validated.Path
            let referencedFragment: ReferencedFragment?
            let isReferencedFragmentASingleFragmentStruct: Bool
        }
        
        static let pathKey = Context.Key.resolved
    }

}

extension Stage.Resolved.ReferencedFragment {

    var fragment: GraphQLFragment {
        switch self {
        case .fragment(let fragment):
            return fragment
        case .connection(let connection):
            return connection.fragment
        case .mutationResult(let fragment):
            return fragment
        }
    }

}

extension Stage.Resolved.Path {

    var isMutation: Bool {
        return validated.parsed.target == .mutation
    }

    var isConnection: Bool {
        guard case .connection = referencedFragment else { return false }
        return true
    }

}

extension Struct where CurrentStage: ResolvedStage {
    
    var singleFragment: GraphQLFragment? {
        guard let fragment = fragments.first,
            fragments.count == 1,
            mutations.isEmpty,
            properties.filter({ $0.graphqlPath == nil }).isEmpty else { return nil }
        
        return fragment
    }
    
}
