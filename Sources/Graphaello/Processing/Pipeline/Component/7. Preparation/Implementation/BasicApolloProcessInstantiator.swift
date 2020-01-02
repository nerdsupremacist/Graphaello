//
//  BasicApolloProcessInstantiator.swift
//  
//
//  Created by Mathias Quintero on 31.12.19.
//

import Foundation
import CLIKit

struct BasicApolloProcessInstantiator: ApolloProcessInstantiator {
    
    func process(for apollo: ApolloReference, schema: Path, graphql: Path, outputFile: Path) throws -> Process {
        let path = try apollo.scriptPath()
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.arguments = [path.string] + apollo.arguments(schema: schema, graphql: graphql, outputFile: outputFile)
        task.standardOutput = nil
        task.standardError = nil
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
    
    fileprivate func arguments(schema: Path, graphql: Path, outputFile: Path) -> [String] {
        return [
            command,
            "--namespace=ApolloStuff",
            "--target=swift",
            "--includes=\(graphql)",
            "--localSchemaFile=\(schema)",
            "\(outputFile)",
        ]
    }
    
    fileprivate func scriptPath() throws -> Path {
        switch self {
        case .binary:
            return try ExecutableFinder.find("apollo") ?! ArgumentError.apolloIsNotInstalled
        case .derivedData:
            let buildRoot = try Environment["BUILD_ROOT"].map { Path($0) } ?! ArgumentError.noBuildRootFolderProvided
            return try buildRoot.findSourcePackages() + "checkouts" + "apollo-ios" + "scripts" + "run-bundled-codegen.sh"
        }
    }
    
}

extension Path {
    
    func findSourcePackages() throws -> Path {
        guard self.string != "/" else { throw ArgumentError.invalidDerivedDataFolder }
        let sourcePackages = self + "SourcePackages"
        if sourcePackages.exists && sourcePackages.isDirectory {
            return sourcePackages
        } else {
            return try deletingLastComponent.findSourcePackages()
        }
    }
    
}
