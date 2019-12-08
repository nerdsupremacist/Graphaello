//
//  Struct+initFromParsed.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 12/3/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

extension Struct where CurrentStage == Graphaello.Stage.Parsed {

    init(from extracted: Struct<Stage.Extracted>) throws {
        self = try extracted.map { attributes in
            try attributes.compactMap { try Stage.Parsed.Path(from: $0) }.first
        }
    }

}
