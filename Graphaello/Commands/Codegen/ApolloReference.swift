//
//  ApolloReference.swift
//  Graphaello
//
//  Created by Mathias Quintero on 11.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import CLIKit

enum ApolloReference: String {
    case binary
    case derivedData
    
}

extension ApolloReference: CommandArgumentValue {
    
    var description: String {
        return "Reference to Apollo CLI"
    }
    
    init(argumentValue: String) throws {
        self = ApolloReference(rawValue: argumentValue) ?! fatalError("")
    }
    
}

extension ApolloReference {
    
    func process(schema: Path, graphql: Path, outputFile: Path) throws -> Process {
        let path = try scriptPath()
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.arguments = [path.string] + arguments(schema: schema, graphql: graphql, outputFile: outputFile)
        return task
    }
    
}

extension ApolloReference {
    
    private var command: String {
        switch self {
        case .binary:
            return "client:codegen"
        case .derivedData:
            return "codegen:generate"
        }
    }
    
    private func arguments(schema: Path, graphql: Path, outputFile: Path) -> [String] {
        return [
            command,
            "--target=swift",
            "--includes=\(graphql)",
            "--localSchemaFile=\(schema)",
            "\(outputFile)",
        ]
    }
    
    private func scriptPath() throws -> Path {
        switch self {
        case .binary:
            return ExecutableFinder.find("apollo") ?! fatalError("Failed to find apollo")
        case .derivedData:
            let buildRoot = Environment["BUILD_ROOT"].map { Path($0) } ?! fatalError("No build root folder given")
            return try buildRoot.findSourcePackages() + "checkouts" + "apollo-ios" + "scripts" + "run-bundled-codegen.sh"
        }
    }
    
}

extension Path {
    
    func findSourcePackages() throws -> Path {
        guard self.string != "/" else { fatalError("") }
        let sourcePackages = self + "SourcePackages"
        if sourcePackages.exists && sourcePackages.isDirectory {
            return sourcePackages
        } else {
            return try deletingLastComponent.findSourcePackages()
        }
    }
    
}
