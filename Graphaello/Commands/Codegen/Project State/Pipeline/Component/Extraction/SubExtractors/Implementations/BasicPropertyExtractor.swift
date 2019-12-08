//
//  BasicPropertyExtractor.swift
//  Graphaello
//
//  Created by Mathias Quintero on 12/8/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

enum BasicPropertyExtractor<Attribute: AttributeExtractor>: PropertyExtractor {
    static func extract(code: SourceCode) throws -> Property<Stage.Extracted> {
        let attributes = try code
            .optional { try $0.attributes() }?
            .map { try Attribute.extract(code: $0) } ?? []

        return Property(code: code,
                        name: try code.name(),
                        type: try code.typeName(),
                        info: attributes)
    }
}