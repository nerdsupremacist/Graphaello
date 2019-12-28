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
        guard context["isInsideFragment"] == nil else { return ["name": name] }
        switch self {
        case .direct:
            return ["name": name]
        case .call(_, let arguments):
            let sortedKeys = arguments.sorted { $0.name <= $1.name }
            return [
                "name": name,
                "arguments": sortedKeys.map {
                    FieldArgument(name: $0.name, queryArgumentName: $0.queryArgumentName)
                } as [FieldArgument]
            ]
        }
    }
}
