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
import PathKit

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
        
        let codegen = try project.state(sourcesPath: sourcesPath).validated().codegen()

        let formatted = try codegen.generate()
        print(formatted)
    }
}
