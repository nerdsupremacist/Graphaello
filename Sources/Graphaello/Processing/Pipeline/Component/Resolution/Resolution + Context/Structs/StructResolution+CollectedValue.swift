import Foundation

extension StructResolution {

    enum CollectedValue {
        case query(GraphQLQuery)
        case mutation(GraphQLMutation)
        case fragment(GraphQLFragment)
        case connectionQuery(GraphQLConnectionQuery)
    }
    
}

extension Struct where CurrentStage == Stage.Resolved {
    
    static func + (lhs: Struct<Stage.Resolved>, rhs: StructResolution.CollectedValue) throws -> Struct<Stage.Resolved> {
        switch rhs {
        case .query(let query):
            return try lhs + query
        case .mutation(let mutation):
            return lhs + mutation
        case .fragment(let fragment):
            return lhs + fragment
        case .connectionQuery(let connectionQuery):
            return lhs + connectionQuery
        }
    }
    
}
