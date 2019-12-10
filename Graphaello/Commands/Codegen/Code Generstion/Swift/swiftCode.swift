//
//  swiftCode.swift
//  Graphaello
//
//  Created by Mathias Quintero on 10.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SwiftFormat

func swiftCode(@SwiftCodeBuilder builder: () -> SwiftCodeTransformable) throws -> String {
    let transformable = builder()
    return try format(try transformable.code(using: .custom))
}
