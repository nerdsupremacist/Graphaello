//
//  GraphQLType+SwiftCodeTransformable.swift
//  Graphaello
//
//  Created by Mathias Quintero on 06.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import Stencil

extension Schema.GraphQLType: ExtraValuesSwiftCodeTransformable {

    func arguments(from context: Context, arguments: [Any?]) throws -> [String : Any] {
        return [
            "hasEnumValues": enumValues.map { !$0.isEmpty } ?? false
        ]
    }

}
