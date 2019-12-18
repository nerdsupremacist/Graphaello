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
        let transpiler = BasicGraphQLToSwiftTranspiler()
        let api = context["api"] as? API ?! fatalError("API Not found")
        return [
            "needsInitializer": inputFields?.contains { $0.defaultValue != nil } ?? false,
            "hasEnumValues": enumValues.map { !$0.isEmpty } ?? false,
            "inputFieldInitializerArguments": try inputFieldInitializerArguments(using: transpiler, in: api)
        ]
    }

}
