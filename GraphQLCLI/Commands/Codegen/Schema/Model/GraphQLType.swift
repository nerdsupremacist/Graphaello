//
//  GraphQLType.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 12/4/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

extension Schema {

    struct GraphQLType: Codable {
        let name: String
        let kind: Kind
        let fields: [Field]?
    }

}

extension Schema.GraphQLType {

    var isScalar: Bool {
        return kind == .scalar
    }
    
    var includeInReport: Bool {
        return kind == .object && !name.starts(with: "__")
    }

}
