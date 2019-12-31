//
//  Validated.swift
//  Graphaello
//
//  Created by Mathias Quintero on 12/8/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

extension Stage {

    // The GraphQL Paths have been type checked and bundled with the respective Types
    // + All default arguments have been injected.
    enum Validated: GraphQLStage {
        struct Component {
            enum Reference {
                enum Casting {
                    case up
                    case down
                }

                case field(Schema.GraphQLType.Field)
                case fragment
                case casting(Casting)
            }
            
            let reference: Reference
            let underlyingType: Schema.GraphQLType
            let parsed: Parsed.Component
        }

        struct Path {
            let parsed: Parsed.Path
            let api: API
            let target: Schema.GraphQLType
            let components: [Component]
        }
        
        static let pathKey = Context.Key.validated
    }

}

extension Stage.Validated.Component {
    
    var fieldType: Schema.GraphQLType.Field.TypeReference {
        switch reference {
        case .field(let field):
            return field.type
        case .fragment, .casting:
            return .concrete(.init(kind: underlyingType.kind, name: underlyingType.name))
        }
    }
    
}

extension Context.Key where T == Stage.Validated.Path? {
    
    static let validated = Context.Key<Stage.Validated.Path?>()
    
}
