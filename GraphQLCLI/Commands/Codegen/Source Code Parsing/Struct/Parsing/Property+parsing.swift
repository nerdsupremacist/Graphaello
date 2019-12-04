//
//  Property+parsing.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 12/4/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

extension Property {

    init(from parsed: ParsedProperty) throws {
        self.init(name: parsed.name,
                  type: parsed.type,
                  graphqlPath: try parsed.attributes.compactMap { try GraphQLPath(from: $0) }.first)
    }

}
