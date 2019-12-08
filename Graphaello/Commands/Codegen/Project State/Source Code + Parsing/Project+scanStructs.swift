//
//  Project+scanStructs.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 12/1/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import PathKit
import SourceKittenFramework

extension Project {

    func scanStructs() throws -> [Struct<Stage.Parsed>] {
        return try files()
            .filter { $0.extension == "swift" }
            .map { $0.string }
            .filter { !$0.contains("GraphQL Stuff") }
            .compactMap { File(path: $0) }
            .map { try StructuredFile(file: $0) }
            .flatMap { try $0.structs() }
            .map { try Struct(from: $0) }
    }

}
