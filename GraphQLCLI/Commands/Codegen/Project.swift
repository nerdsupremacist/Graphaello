//
//  Project.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 12/5/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import PathKit
import CLIKit
import XcodeProj

struct Project {
    private let xcodeProject: XcodeProj
    private let sourcesPath: String

    init(path: CLIKit.Path) throws {
        xcodeProject = try XcodeProj(pathString: path.string)
        sourcesPath = path.deletingLastComponent.string
    }
}

extension Project {

    func files() throws -> [PathKit.Path] {
        return try xcodeProject
            .pbxproj
            .buildFiles
            .compactMap { try $0.file?.fullPath(sourceRoot: .init(sourcesPath)) }
    }

}
