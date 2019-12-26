//
//  AttributeExtractor.swift
//  Graphaello
//
//  Created by Mathias Quintero on 12/8/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

protocol AttributeExtractor {
    func extract(code: SourceCode) throws -> Stage.Extracted.Attribute
}
