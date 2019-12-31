//
//  Parsed.swift
//  Graphaello
//
//  Created by Mathias Quintero on 12/8/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

extension Stage {

    // The GraphQL Property Wrappers have been parsed
    enum Parsed: GraphQLStage {
        typealias Information = Path?

        enum Component: Equatable {
            case property(String)
            case fragment
            case call(String, [Field.Argument])
        }

        struct Path {
            let apiName: String
            let target: Target
            let components: [Component]
        }
        
        static var pathKey = Context.Key.parsed
    }

}

extension Context.Key where T == Stage.Parsed.Path? {
    
    static let parsed = Context.Key<Stage.Parsed.Path?>()
    
}
