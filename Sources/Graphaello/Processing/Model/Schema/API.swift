//
//  API.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 12/4/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import PathKit

class API {
    let name: String
    let query: Schema.GraphQLType
    let types: [Schema.GraphQLType]
    let scalars: [Schema.GraphQLType]
    let path: Path

    init(name: String, schema: Schema, path: Path) {
        self.name = name

        self.query = schema.types.first { $0.name == schema.queryType.name } ?! fatalError("Expected a query type")

        self.types = schema.types
            .filter { $0.includeInReport }
            .filter { $0.name != schema.queryType.name }
        
        self.scalars = schema.types.filter { $0.isScalar }
        self.path = path
    }
}

extension API: Hashable {

    static func == (lhs: API, rhs: API) -> Bool {
        return lhs.name == rhs.name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }

}
