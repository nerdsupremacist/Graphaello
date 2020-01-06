//
//  Schema.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 29.11.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

struct Schema: Codable {
    let types: [GraphQLType]
    let queryType: TypeReference
    let mutationType: TypeReference?
}
