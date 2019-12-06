//
//  Codegen.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 04.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

struct Codegen {
    let apis: [API]
    let structs: [GraphQLStruct]
}

extension Codegen {

    func generate() throws -> String {
        return try swiftCode {
            StructureAPI()
            apis
            structs
        }
    }

}
