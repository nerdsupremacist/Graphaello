//
//  GraphQLError.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 11/29/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import CLIKit
import SourceKittenFramework

enum ParseError: Error, CustomStringConvertible {
    case missingKey(String, in: SourceCode)
    case valueNotTransformable(SourceKitRepresentable, to: SourceKitRepresentable.Type, in: SourceCode)
    case expectedSingleSubtructure(in: [SourceCode])

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
        }
    }

    var localizedDescription: String {
        return description
    }
}

enum GraphQLError: Error, CustomStringConvertible {
    case pathDoesNotExist(String)
    case noProjectFound(at: Path)
    case fileIsNotAProject(Path)

    var description: String {
        switch self {
        case .pathDoesNotExist(let path):
            return "Given path does not exist: \(path)"
        case .noProjectFound(let path):
            return "There is no Xcode Project in the provided folder: \(path.string)"
        case .fileIsNotAProject(let path):
            return "The file provided is not an Xcode Project: \(path.string)"
        }
    }

    var localizedDescription: String {
        return description
    }
}
