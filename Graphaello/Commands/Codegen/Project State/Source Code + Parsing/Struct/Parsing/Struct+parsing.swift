//
//  Struct+initFromParsed.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 12/3/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

extension Struct where Component == StandardComponent {

    init(from parsed: ParsedStruct) throws {
        self.init(name: parsed.name,
                  properties: try parsed.properties.filter { try !$0.isComputed() }.map { try Property(from: $0) })
    }

}
