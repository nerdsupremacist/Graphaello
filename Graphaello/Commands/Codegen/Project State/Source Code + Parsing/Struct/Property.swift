//
//  Property.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 12/4/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

struct Property<Component> {
    let name: String
    let type: String
    let graphqlPath: GraphQLPath<Component>?
}
