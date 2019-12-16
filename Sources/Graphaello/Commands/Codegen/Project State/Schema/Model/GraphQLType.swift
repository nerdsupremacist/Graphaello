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
        let possibleTypes: [TypeReference]?
        let interfaces: [TypeReference]?
    }

}

extension Schema.GraphQLType {

    var isScalar: Bool {
        return kind == .scalar
    }
    
    var includeInReport: Bool {
        let hasAnything = !fields.isEmpty || !possibleTypes.isEmpty || !interfaces.isEmpty
        return kind != .scalar && !name.starts(with: "__") && hasAnything
    }

}

extension Optional where Wrapped: Collection {

    fileprivate var isEmpty: Bool {
        return self?.isEmpty ?? true
    }

}
