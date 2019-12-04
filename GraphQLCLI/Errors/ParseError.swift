//
//  ParseError.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 12/4/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import SwiftSyntax
import SourceKittenFramework

enum ParseError: Error, CustomStringConvertible {
    case missingKey(String, in: SourceCode)
    case valueNotTransformable(SourceKitRepresentable, to: SourceKitRepresentable.Type, in: SourceCode)
    case expectedSingleSubtructure(in: [SourceCode])
    case cannotInstantiateObjectFromExpression(ExprSyntax, type: Any.Type)
    case expectedBaseForCalls(expression: ExprSyntax)

    var description: String {
        switch self {

        case .missingKey(let key, let code):
            return """
            Missing Key \(key)
            in {\(code.dictionary.keys.joined(separator: ", "))}

            Code:
            \(code.content)
            """
        case .valueNotTransformable(let value, let type, let code):
            return """
            Value \(value)
            cannot be converted to \(type)

            Code:
            \(code.content)
            """

        case .expectedSingleSubtructure(let code):
            return """
            Expected expression to be a single structure.

            Found: \(code.enumerated().map { "\($0.offset + 1) -> \n\($0.element.content)" }.joined(separator: "\n\n"))
            """
        case .cannotInstantiateObjectFromExpression(let expression, let type):
            return """
            Cannot instantiate \(type) from expression:

            \(expression)
            """
        case .expectedBaseForCalls(let expression):
            return """
            Expected a base for a method or member access call:

            \(expression)
            """
        }
    }

    var localizedDescription: String {
        return description
    }
}
