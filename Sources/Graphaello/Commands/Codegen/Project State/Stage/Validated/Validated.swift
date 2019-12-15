//
//  Validated.swift
//  Graphaello
//
//  Created by Mathias Quintero on 12/8/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

extension Stage {

    enum Validated: GraphQLStage {
        typealias Information = Path?

        struct Component {
            enum Reference {
                case field(Schema.GraphQLType.Field)
                case fragment
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
    }

}

extension Stage.Validated.Component {
    
    var fieldType: Schema.GraphQLType.Field.TypeReference {
        switch reference {
        case .field(let field):
            return field.type
        case .fragment:
            return .concrete(.init(kind: .object, name: underlyingType.name))
        }
    }
    
}
