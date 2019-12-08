//
//  BasicStructExtractor.swift
//  Graphaello
//
//  Created by Mathias Quintero on 12/8/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

enum BasicStructExtractor<Property: PropertyExtractor>: StructExtractor {
    static func extract(code: SourceCode) throws -> Struct<Stage.Extracted> {
        let properties = try code.substructure()
            .filter { try $0.kind() == .varInstance }
            .map { try Property.extract(code: $0) }

        return Struct(code: code,
                      name: try code.name(),
                      properties: properties)
    }
}
