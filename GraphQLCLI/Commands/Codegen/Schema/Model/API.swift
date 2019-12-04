//
//  API.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 12/4/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

class API {
    let name: String

    let query: Schema.GraphQLType

    let types: [Schema.GraphQLType]
    
    let scalars: [Schema.GraphQLType]

    init(name: String, schema: Schema) {
        self.name = name

        self.query = schema.types.first { $0.name == schema.queryType.name } ?! fatalError("Expected a query type")

        self.types = schema.types
            .filter { $0.includeInReport }
            .filter { $0.name != schema.queryType.name }
        
        self.scalars = schema.types.filter { $0.isScalar }
    }
}
