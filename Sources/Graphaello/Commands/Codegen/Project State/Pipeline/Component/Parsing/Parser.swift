//
//  Parser.swift
//  Graphaello
//
//  Created by Mathias Quintero on 12/8/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

protocol Parser {
    func parse(extracted: Struct<Stage.Extracted>) throws -> Struct<Stage.Parsed>
}
