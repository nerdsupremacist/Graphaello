//
//  Parsed.swift
//  Graphaello
//
//  Created by Mathias Quintero on 12/8/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

extension Stage {

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

}
