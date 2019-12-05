//
//  Project.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 12/5/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import CLIKit
import XcodeProj

struct Project {
    let xcodeProject: XcodeProj
    let sourcesPath: String

    init(path: Path) throws {
        xcodeProject = try XcodeProj(pathString: path.string)
        sourcesPath = path.deletingLastComponent.string
    }
}
