//
//  InputField+SwiftCodeTransformable.swift
//  
//
//  Created by Mathias Quintero on 12/17/19.
//

import Foundation
import Stencil

extension Schema.GraphQLType.InputField: ExtraValuesSwiftCodeTransformable {

    func arguments(from context: Context, arguments: [Any?]) throws -> [String : Any] {
        let api = context["api"] as? API ?! fatalError("API Not found")
        return [
            "swiftType" : type.swiftType(api: api.name),
        ]
    }

}
