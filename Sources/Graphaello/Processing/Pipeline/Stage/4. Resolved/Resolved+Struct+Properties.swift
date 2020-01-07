//
//  Resolved+Struct+Properties.swift
//  
//
//  Created by Mathias Quintero on 31.12.19.
//

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
    
    init(code: SourceCode,
         name: String,
         properties: [Property<CurrentStage>],
         fragments: [GraphQLFragment],
         query: GraphQLQuery?,
         connectionQueries: [GraphQLConnectionQuery],
         mutations: [GraphQLMutation]) {
        
        self.init(code: code, name: name, properties: properties) {
            (.fragments ~> fragments)
            (.query ~> query)
            (.connectionQueries ~> connectionQueries)
            (.mutations ~> mutations)
        }
    }
    
}
