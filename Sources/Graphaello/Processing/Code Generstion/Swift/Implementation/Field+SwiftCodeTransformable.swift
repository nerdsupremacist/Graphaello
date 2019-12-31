//
//  Field+SwiftCodeTransformable.swift
//  Graphaello
//
//  Created by Mathias Quintero on 06.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import Stencil

extension Schema.GraphQLType.Field: ExtraValuesSwiftCodeTransformable {
    
    func arguments(from context: Stencil.Context, arguments: [Any?]) throws -> [String : Any] {
        let isStatic = arguments.contains { $0 as? String == "static" }
        let isOptional = arguments.contains { $0 as? String == "optional" }
        
        let hasArguments = !self.arguments.isEmpty
        let pathClass = type.isFragment ? "FragmentPath" : "Path"
        
        let api = context["api"] as? API ?! fatalError("API Not found")
        let swiftType = isOptional ? type.optional.swiftType(api: api.name) : type.swiftType(api: api.name)
        
        return [
            "isStatic" : isStatic,
            "hasArguments" : hasArguments,
            "pathClass" : pathClass,
            "swiftType" : swiftType
        ]
    }
    
}
