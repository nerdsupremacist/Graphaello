//
//  Resolved.swift
//  Graphaello
//
//  Created by Mathias Quintero on 12/8/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

extension Stage {

    enum Resolved: GraphQLStage {
        typealias Information = Path?

        enum ReferencedFragment {
            case fragment(GraphQLFragment)
            case connection(GraphQLConnectionFragment)
        }

        struct Path {
            let validated: Validated.Path
            let referencedFragment: ReferencedFragment?
        }
    }

}

extension Stage.Resolved.ReferencedFragment {

    var fragment: GraphQLFragment {
        switch self {
        case .fragment(let fragment):
            return fragment
        case .connection(let connection):
            return connection.fragment
        }
    }

}

extension Stage.Resolved.Path {

    var isConnection: Bool {
        guard case .connection = referencedFragment else { return false }
        return true
    }

}
