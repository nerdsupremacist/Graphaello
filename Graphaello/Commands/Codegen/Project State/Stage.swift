//
//  Stage.swift
//  Graphaello
//
//  Created by Mathias Quintero on 12/7/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

protocol StageProtocol {
    associatedtype Information
}

protocol GraphQLStage: StageProtocol where Information == Path? {
    associatedtype Path
}

extension Property where CurrentStage: GraphQLStage {

    var graphqlPath: CurrentStage.Path? {
        return info
    }

}

enum Stage {
    enum Extracted: StageProtocol {
        typealias Information = [ParsedAttribute]
    }

    enum Parsed: GraphQLStage {
        typealias Information = Path?

        enum Component: Equatable {
            case property(String)
            case fragment
            case call(String, [String : Argument])
        }

        struct Path {
            let apiName: String
            let target: Target
            let components: [Component]
        }
    }

    enum Validated: GraphQLStage {
        typealias Information = Path?

        struct Component {
            let fieldType: Schema.GraphQLType.Field.TypeReference
            let underlyingType: Schema.GraphQLType
            let parsed: Parsed.Component
        }

        struct Path {
            let parsed: Parsed.Path
            let components: [Component]
        }
    }

    enum Resolved: GraphQLStage {
        typealias Information = Path?
        struct Path {
            let validated: Validated.Path
        }
    }
}
