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

        struct Path {
            let validated: Validated.Path
            let referencedFragment: GraphQLFragment?
        }
    }

}
