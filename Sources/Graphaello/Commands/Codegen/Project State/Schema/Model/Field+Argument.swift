//
//  Argument.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 12/4/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

extension Schema.GraphQLType.Field {

    struct Argument: Codable, Equatable, Hashable {
        let name: String
        let defaultValue: String?
        let `type`: TypeReference
    }

}
