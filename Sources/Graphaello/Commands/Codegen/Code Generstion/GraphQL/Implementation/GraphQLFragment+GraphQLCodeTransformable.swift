//
//  GraphQLFragment+GraphQLCodeTransformable.swift
//  Graphaello
//
//  Created by Mathias Quintero on 11.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import Stencil

extension GraphQLFragment: ExtraValuesGraphQLCodeTransformable {

    func arguments(from context: Context, arguments: [Any?]) throws -> [String : Any] {
        return ["isInsideFragment": true]
    }

}
