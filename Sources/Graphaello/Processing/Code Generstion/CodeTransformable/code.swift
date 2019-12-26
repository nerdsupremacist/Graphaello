//
//  code.swift
//  Graphaello
//
//  Created by Mathias Quintero on 10.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SwiftFormat

private let formattingThreshold = 500_000

func code(@CodeBuilder builder: () -> CodeTransformable) throws -> String {
    let transformable = builder()
    let code = try transformable.code(using: .custom)
    if code.count > formattingThreshold {
        // Shouldn't do any formatting on this
        return code
    } else {
        return try format(code)
    }
}
