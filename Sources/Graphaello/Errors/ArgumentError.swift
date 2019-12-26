//
//  GraphQLError.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 11/29/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import CLIKit

enum ArgumentError: Error, CustomStringConvertible {
    case pathDoesNotExist(String)
    case noProjectFound(at: Path)
    case fileIsNotAProject(Path)
    case invalidApolloReference(String)
    case apolloIsNotInstalled
    case noBuildRootFolderProvided
    case invalidDerivedDataFolder

    var description: String {
        switch self {
        case .pathDoesNotExist(let path):
            return "Given path does not exist: \(path)"
        case .noProjectFound(let path):
            return "There is no Xcode Project in the provided folder: \(path.string)"
        case .fileIsNotAProject(let path):
            return "The file provided is not an Xcode Project: \(path.string)"
        case .invalidApolloReference(let reference):
            return "\"\(reference)\" is not a valid option for a reference to apollo"
        case .apolloIsNotInstalled:
            return "Apollo from binary was selected, but Apollo is not installed"
        case .noBuildRootFolderProvided:
            return "Apollo from derived data was selected, but no $BUILD_ROOT value could be found. Try running from Xcode"
        case .invalidDerivedDataFolder:
            return "The Derived Data folder provided appears to not include the checkouts of Swift Package Manager"
        }
    }

    var localizedDescription: String {
        return description
    }
}
