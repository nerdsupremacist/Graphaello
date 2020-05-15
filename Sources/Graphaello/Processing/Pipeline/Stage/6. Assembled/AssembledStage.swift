import Foundation

protocol AssembledStage: ResolvedStage { }

extension Project.State where CurrentStage: AssembledStage {
    
    var requests: [ApolloCodeGenRequest] {
        return context[.requests]
    }
    
}

extension Context.Key where T == [ApolloCodeGenRequest] {
    
    static let requests = Context.Key<[ApolloCodeGenRequest]>()
    
}
