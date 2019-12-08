//
//  Extractor.swift
//  Graphaello
//
//  Created by Mathias Quintero on 12/8/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SourceKittenFramework

protocol Extractor {
    func extract(from file: File) throws -> [Struct<Stage.Extracted>]
}
