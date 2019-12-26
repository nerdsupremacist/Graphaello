//
//  Definition.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 12/4/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

extension Schema.GraphQLType.Field.TypeReference {

    struct Definition: Codable, Equatable, Hashable {
        let kind: Schema.GraphQLType.Kind
        let name: String?
    }

}
