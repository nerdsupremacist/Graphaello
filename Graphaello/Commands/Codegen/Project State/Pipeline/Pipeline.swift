//
//  Pipeline.swift
//  Graphaello
//
//  Created by Mathias Quintero on 12/8/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SourceKittenFramework

protocol Pipeline {
    func extract(from file: File) throws -> [Struct<Stage.Extracted>]
    func parse(structs: Struct<Stage.Extracted>) throws -> Struct<Stage.Parsed>
    func validate(struct: Struct<Stage.Parsed>) throws -> Struct<Stage.Validated>
    func resolve(structs: [Struct<Stage.Validated>]) throws -> [GraphQLStruct]
}
