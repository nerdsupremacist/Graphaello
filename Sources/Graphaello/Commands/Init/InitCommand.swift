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
                   description: "Path to Xcode Project using GraphQL.")
    var project: ProjectPath

    @CommandFlag(description: "Don't inject a custom build phase.")
    var skipBuildPhase: Bool

    @CommandFlag(description: "Skip the code generation step.")
    var skipGencode: Bool

    @CommandFlag(description: "Should not cache generated code.")
    var skipCache: Bool

    @CommandOption(default: 100, description: "Maximum number of items that should be cached.")
    var cacheSize: Int

    var description: String {
        return "Configures Graphaello for an Xcode Project"
    }

    func run() throws {
        Console.print(title: "🚀 Initializing Project")
        let project = try self.project.open()
        try project.addGraphaelloMacrosToEachTarget()

        Console.print(title: "🛠  Integrating Apollo")
        let integratedPackage = try project.addDependencyIfNotThere(name: "apollo-ios",
                                                                    productName: "Apollo",
                                                                    repositoryURL: "https://github.com/apollographql/apollo-ios.git",
                                                                    version: .upToNextMajorVersion("0.28.0"))

        if integratedPackage {
            Console.print(result: "Successfully added Apollo Package")
        } else {
            Console.print(result: "Apollo was already integrated")
        }

        if !skipBuildPhase {
            Console.print(title: "🤘 Injecting Graphaello Build Phase")
            let addedBuildPhase = try project.addBuildPhaseIfNotThrere(name: "Graphaello", code: script)

            if addedBuildPhase {
                Console.print(result: "Added Build Phase")
            } else {
                Console.print(result: "Build Phase was already in place")
            }
        }

        Console.print("")
        
        if !skipGencode {
            let codegen = CodegenCommand()
            codegen.project = self.project
            codegen.apollo = .binary
            codegen.skipCache = skipCache
            codegen.cacheSize = cacheSize
            try codegen.run()
        } else {
            Console.print("✅ Done")
        }
    }
}
