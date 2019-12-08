//
//  StandardExtractor.swift
//  Graphaello
//
//  Created by Mathias Quintero on 12/8/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SourceKittenFramework

struct BasicExtractor: Extractor {
    let extractor: StructExtractor

    func extract(from file: File) throws -> [Struct<Stage.Extracted>] {
        let code = try SourceCode(file: file)
        let structs = try code.structs()
        return try structs.map { try extractor.extract(code: $0) }
    }
}

extension SourceCode {

    fileprivate func structs() throws -> [SourceCode] {
        let kind = try optional { try $0.kind() }
        let substructure = try optional { try $0.substructure() } ?? []
        if kind == .struct {
            return try substructure.flatMap { try $0.structs() } + [self]
        } else {
            return try substructure.flatMap { try $0.structs() }
        }
    }

}
