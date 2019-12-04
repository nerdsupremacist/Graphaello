//
//  Field.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 12/4/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

extension Schema.GraphQLType {

    struct Field: Codable {
        enum CodingKeys: String, CodingKey {
            case name
            case arguments = "args"
            case type
        }

        let name: String
        let arguments: [Argument]
        let `type`: TypeReference
    }

}
