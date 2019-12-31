//
//  Assembled.swift
//  
//
//  Created by Mathias Quintero on 31.12.19.
//

import Foundation

extension Stage {
    
    // All queries and fragments were assembled into GraphQL Code
    enum Assembled: GraphQLStage, AssembledStage {
        static var pathKey = Context.Key.cleaned
    }
    
}
