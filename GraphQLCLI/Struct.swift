//
//  Struct.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 12/1/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SourceKittenFramework

struct Struct {
    enum PropertyType {
        case argument(type: String)
        case fragment(object: String, path: [String])
        case query(path: [String])
    }

    let file: File
    let name: String
    let properties: [String : PropertyType]
}
