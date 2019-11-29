//
//  GraphQLError.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 11/29/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import CLIKit

enum GraphQLError: Error {
    case pathDoesNotExist(String)
    case noProjectFound(at: Path)
    case fileIsNotAProject(Path)

    var localizedDescription: String {
        switch self {
        case .pathDoesNotExist(let path):
            return "Given path does not exist: \(path)"
        case .noProjectFound(let path):
            return "There is no Xcode Project in the provided folder: \(path.string)"
        case .fileIsNotAProject(let path):
            return "The file provided is not an Xcode Project: \(path.string)"
        }
    }
}
