//
//  BasicAttributeExtractor.swift
//  Graphaello
//
//  Created by Mathias Quintero on 12/8/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

struct BasicAttributeExtractor: AttributeExtractor {

    func extract(code: SourceCode) throws -> Stage.Extracted.Attribute {
        return Stage.Extracted.Attribute(code: code, kind: try code.attribute())
    }

}
