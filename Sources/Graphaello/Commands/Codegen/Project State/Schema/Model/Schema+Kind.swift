//
//  Kind.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 12/4/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

extension Schema.GraphQLType {

    enum Kind: String, Codable, Equatable, Hashable {
        case scalar = "SCALAR"
        case object = "OBJECT"
        case list = "LIST"
        case nonNull = "NON_NULL"
        case `enum` = "ENUM"
        case interface = "INTERFACE"
        case inputObject = "INPUT_OBJECT"
        case union = "UNION"
    }
    
}
