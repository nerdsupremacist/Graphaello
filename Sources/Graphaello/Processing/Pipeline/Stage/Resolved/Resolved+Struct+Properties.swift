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
    
    init(code: SourceCode,
         name: String,
         properties: [Property<CurrentStage>],
         fragments: [GraphQLFragment],
         query: GraphQLQuery?,
         connectionQueries: [GraphQLConnectionQuery]) {
        
        self.init(code: code, name: name, properties: properties) {
            (.fragments ~> fragments)
            (.query ~> query)
            (.connectionQueries ~> connectionQueries)
        }
    }
    
}
