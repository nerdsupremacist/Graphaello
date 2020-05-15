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

