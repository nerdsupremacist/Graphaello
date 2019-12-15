//
//  InitCommand.swift
//  
//
//  Created by Mathias Quintero on 12/15/19.
//

import Foundation
import CLIKit
import XcodeProj
import PathKit

private let script = """
if ! type "graphaello" > /dev/null; then
  echo "warning: graphaello is not installed on your machine. Your project won't be updated automatically"
  exit 0
fi
graphaello codegen --project $PROJECT_FILE_PATH --apollo derivedData
"""

class InitCommand : Command {
    @CommandOption(default: .first(Path.currentDirectory),
                   description: "Path to Xcode Project usind GraphQL")
    var project: ProjectPath

    var description: String {
        return "Configures Graphaello for an Xcode Project"
    }

    func run() throws {
        let project = try self.project.open()
        try project.addDependencyIfNotThere(name: "apollo-ios",
                                            repositoryURL: "https://github.com/apollographql/apollo-ios.git",
                                            version: .branch("master"))

        try project.addBuildPhaseIfNotThrere(name: "Graphaello", code: script)

        let codegen = CodegenCommand()
        codegen.project = self.project
        codegen.apollo = .derivedData
        try codegen.run()
    }
}
