import Foundation
import CLIKit
import XcodeProj
import PathKit

class ClearCacheCommand : Command {
    @CommandOption(default: .first(Path.currentDirectory),
                   description: "Path to Xcode Project using GraphQL.")
    var project: ProjectPath

    var description: String {
        return "Clears the Graphaello cache for a project"
    }

    func run() throws {
        checkVersion()
        let cache = try PersistentCache<AnyHashable>(project: try project.open(), capacity: 1)
        try cache.clear()
    }
}
