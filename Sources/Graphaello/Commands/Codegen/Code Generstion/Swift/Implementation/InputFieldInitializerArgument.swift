//
//  InputFieldInitializerArgument.swift
//  
//
//  Created by Mathias Quintero on 12/18/19.
//

import Foundation
import Stencil
import SwiftSyntax

struct InputFieldInitializerArgument {
    let name: String
    let api: API
    let type: Schema.GraphQLType.Field.TypeReference
    let defaultValue: ExprSyntax?
}

extension InputFieldInitializerArgument: ExtraValuesSwiftCodeTransformable {

    func arguments(from context: Context, arguments: [Any?]) throws -> [String : Any] {
        return [
            "swiftType": type.swiftType(api: api.name)
        ]
    }

}

extension Schema.GraphQLType {

    func inputFieldInitializerArguments(using transpiler: GraphQLToSwiftTranspiler,
                                        in api: API) throws -> [InputFieldInitializerArgument] {
        guard let inputFields = inputFields else { return [] }
        return try inputFields.map { field in
            let defaultValue = try field.defaultValue.map { try transpiler.expression(from: $0,
                                                                                      for: field.type,
                                                                                      using: api) }

            return InputFieldInitializerArgument(name: field.name,
                                                 api: api,
                                                 type: field.type,
                                                 defaultValue: defaultValue)

        }
    }

}
