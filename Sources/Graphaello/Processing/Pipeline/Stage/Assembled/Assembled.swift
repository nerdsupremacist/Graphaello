import Foundation

extension Stage {
    
    // All queries and fragments were assembled into GraphQL Code
    enum Assembled: GraphQLStage, AssembledStage {
        static var pathKey = Context.Key.cleaned
    }
    
}
