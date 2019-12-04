//
//  Struct.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 12/1/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

struct Struct {
    let name: String
    let properties: [Property]
}

extension Struct {

    var hasGraphQLValues: Bool {
        return properties.contains { $0.graphqlPath != nil }
    }

}
