//
//  Codegen.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 12/1/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SwiftFormat
import Stencil

struct Codegen {
    let apis: [API]
}

extension Codegen {

    func generate() throws -> String {
        let file = try Environment
            .custom
            .renderTemplate(name: "GraphQL.swift.stencil", context: ["apis" : apis])
        
        return try format(file)
    }

}
