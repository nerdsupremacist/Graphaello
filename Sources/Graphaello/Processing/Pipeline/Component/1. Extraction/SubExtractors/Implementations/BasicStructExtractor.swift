//
//  BasicStructExtractor.swift
//  Graphaello
//
//  Created by Mathias Quintero on 12/8/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

struct BasicStructExtractor: StructExtractor {
    let propertyExtractor: PropertyExtractor

    func extract(code: SourceCode) throws -> Struct<Stage.Extracted> {
        let properties = try code.substructure()
            .filter { try $0.kind() == .varInstance }
            .compactMap { try propertyExtractor.extract(code: $0) }
            .filter { try !$0.isComputed() && !$0.hasValue() && !$0.isPrivate() }

        return Struct(code: code,
                      name: try code.name(),
                      properties: properties)
    }
}
