//
//  Cleaned.swift
//  
//
//  Created by Mathias Quintero on 31.12.19.
//

import Foundation

extension Stage {
    
    // Name clashes in each query were cleaned
    enum Cleaned: GraphQLStage, ResolvedStage {
        struct Component {
            let validated: Stage.Validated.Component
            let alias: String?
        }
        
        struct Path {
            let resolved: Resolved.Path
            let components: [Component]
        }
        
        static let pathKey = Context.Key.cleaned
    }
    
}

extension Context.Key where T == Stage.Cleaned.Path? {
    
    static let cleaned = Context.Key<Stage.Cleaned.Path?>()
    
}
