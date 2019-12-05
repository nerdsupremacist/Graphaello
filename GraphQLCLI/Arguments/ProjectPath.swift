//
//  ProjectPath.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 11/29/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import CLIKit

enum ProjectPath {
    case specific(Path)
    case first(Path)
}

extension ProjectPath: CommandArgumentValue {
    init(argumentValue: String) throws {
        let localPath = Path.currentDirectory.appendingComponent(argumentValue)
        if localPath.exists {
            self = try ProjectPath(path: localPath)
        }

        let globalPath = Path(argumentValue)
        if globalPath.exists {
            self = try ProjectPath(path: globalPath)
            return
        }

        throw GraphQLError.pathDoesNotExist(argumentValue)
    }

    init(path: Path) throws {
        if path.isProject {
            self = .specific(path)
        } else if path.isDirectory {
            self = .first(path)
        } else {
            throw GraphQLError.fileIsNotAProject(path)
        }
    }

    var description: String {
        return "Path of the Xcode Project to run"
    }
}

extension ProjectPath {

    private func path() throws -> Path {
        switch self {
        case .specific(let path):
            return path
        case .first(let path):
            return try path
                .contentsOfDirectory(fullPaths: true)
                .first { $0.isProject } ?! GraphQLError.noProjectFound(at: path)
        }
    }

    func open() throws -> Project {
        return try Project(path: try path())
    }

}

extension Path {

    var isProject: Bool {
        return ["xcodeproj", "xcworkspace"].contains(`extension`)
    }

}
