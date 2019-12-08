//
//  ParsedStruct.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 12/1/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

extension Struct where CurrentStage == Stage.Extracted {
    init(code: SourceCode) throws {
        self.code = code
        name = try code.name()
        properties = try code
            .substructure()
            .filter { try $0.kind() == .varInstance }
            .map { try Property(code: $0) }
    }
}
