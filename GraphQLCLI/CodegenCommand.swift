//
//  CodegenCommand.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 11/29/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import CLIKit
import XcodeProj
import SourceKittenFramework

class CodegenCommand : Command {

    @CommandOption(default: .first(Path.currentDirectory),
                   description: "Path to Xcode Project usind GraphQL")
    var project: ProjectPath

    var description: String {
        return "Generates a file with all the boilerplate code for your GraphQL Code"
    }

    func run() throws {
        let projectPath = try project.path()
        let project = try XcodeProj(pathString: projectPath.string)

        let sourcesPath = projectPath.deletingLastComponent.string

        let sourceFiles = try project.pbxproj
            .buildFiles
            .compactMap { try $0.file?.fullPath(sourceRoot: .init(sourcesPath))?.string }
            .compactMap { File(path: $0) }
            .map { try Structure(file: $0) }

        print(sourceFiles)
    }
}
