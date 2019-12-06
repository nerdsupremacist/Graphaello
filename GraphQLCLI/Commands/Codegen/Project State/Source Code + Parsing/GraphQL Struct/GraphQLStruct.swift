//
//  GraphQLStruct.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 06.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

struct GraphQLStruct {
    let definition: Struct
    let fragments: [GraphQLFragment]
    let query: GraphQLQuery?
}
