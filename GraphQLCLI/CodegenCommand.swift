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
import Stencil
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
        
        let apis = try project.apis(sourcesPath: sourcesPath)
        
        let loader = FileSystemLoader(paths: [Path.templates])
        
        let ext = Extension()
        
        ext.registerFilter("isFragment") { value in
            guard let value = value as? Schema.GraphQLType.Field.TypeReference else { return nil }
            return value.isFragment
        }
        
        ext.registerFilter("swiftType") { value in
            guard let value = value as? Schema.GraphQLType.Field.TypeReference else { return nil }
            return value.swiftType
        }
        
        let environment = Environment(loader: loader, extensions: [ext])
        let file = try environment.renderTemplate(name: "GraphQL.swift.stencil", context: ["apis" : apis])
        print(file)
        
//        let sourceFiles = try project.pbxproj
//            .buildFiles
//            .compactMap { try $0.file?.fullPath(sourceRoot: .init(sourcesPath)) }
//            .filter { $0.extension == "swift" }
//            .map { $0.string }
//            .filter { !$0.contains("GraphQL Stuff") }
    }
}
