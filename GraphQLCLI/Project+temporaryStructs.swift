//
//  Project+temporaryStruct.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 12/1/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import XcodeProj
import PathKit
import SourceKittenFramework

extension XcodeProj {

    func scanStructs(sourcesPath: String) throws -> [ParsedStruct] {
        let sourceFiles = try pbxproj
            .buildFiles
            .compactMap { try $0.file?.fullPath(sourceRoot: .init(sourcesPath)) }
            .filter { $0.extension == "swift" }
            .map { $0.string }
            .filter { !$0.contains("GraphQL Stuff") }
            .compactMap { File(path: $0) }
            .map { try StructuredFile(file: $0) }

        return try sourceFiles
            .flatMap { try $0.structs() }
    }

}
