//
//  File.swift
//  
//
//  Created by Mathias.Quintero on 5/11/20.
//

import Foundation
import CLIKit

class UpdateAPICommand : Command {
    @CommandOption(default: .first(Path.currentDirectory),
                   description: "Path to Xcode Project using GraphQL.")
    var project: ProjectPath

    @CommandFlag(description: "Skip the code generation step.")
    var skipGencode: Bool

    @CommandFlag(description: "Should not cache generated code.")
    var skipCache: Bool

    @CommandOption(default: 100, description: "Maximum number of items that should be cached.")
    var cacheSize: Int

    @CommandRequiredInput(description: "Name for the API.")
    var apiName: String

    var description: String {
        return "Updates an API Schema from your project"
    }

    private enum APIUpdateError : Error {
        case noAPIFound(name: String)
        case apiDoesNotHaveADefaultURL(name: String)
    }

    func run() throws {
        Console.print(title: "✍️ Updating Schema for \(apiName)")
        guard let api = try project.open().scanAPIs().first(where: { $0.name.lowercased() == apiName.lowercased() }) else {
            throw APIUpdateError.noAPIFound(name: apiName)
        }

        guard let url = api.url else {
            throw APIUpdateError.apiDoesNotHaveADefaultURL(name: apiName)
        }

        let addAPICommand = AddAPICommand()
        addAPICommand.apiName = apiName
        addAPICommand.project = project
        addAPICommand.skipGencode = skipGencode
        addAPICommand.skipCache = skipCache
        addAPICommand.cacheSize = cacheSize
        addAPICommand.url = url
        try addAPICommand.run()
    }
}
