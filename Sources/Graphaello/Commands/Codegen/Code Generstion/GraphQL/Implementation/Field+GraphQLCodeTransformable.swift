//
//  Field+GraphQLCodeTransformable.swift
//  Graphaello
//
//  Created by Mathias Quintero on 11.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import Stencil

extension Field: ExtraValuesGraphQLCodeTransformable {
    func arguments(from context: Context, arguments: [Any?]) throws -> [String : Any] {
        switch self {
        case .direct:
            return ["name": name]
        case .call(_, let arguments):
            return ["name": name, "arguments": arguments.keys.sorted().map { FieldArgument(name: $0) }]
        }
    }
}
