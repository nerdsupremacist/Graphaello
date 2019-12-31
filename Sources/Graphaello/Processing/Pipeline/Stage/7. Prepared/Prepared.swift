//
//  Prepared.swift
//  
//
//  Created by Mathias Quintero on 31.12.19.
//

import Foundation

extension Stage {
    
    // The GraphQL Code was given to Apollo and the Networking Code was Generated
    // Project is read to be turned into Swift Code
    enum Prepared: GraphQLStage, AssembledStage {
        static var pathKey = Context.Key.cleaned
    }
    
}

extension Project.State where CurrentStage == Stage.Prepared {
    
    var responses: [ApolloCodeGenResponse] {
        return context[.responses]
    }
    
}

extension Context.Key where T == [ApolloCodeGenResponse] {
    
    static let responses = Context.Key<[ApolloCodeGenResponse]>()
    
}
