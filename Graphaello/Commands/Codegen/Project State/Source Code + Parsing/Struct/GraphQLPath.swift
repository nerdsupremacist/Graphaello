//
//  GraphQLPath.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 12/4/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

import SwiftSyntax

struct GraphQLPath<Component> {
    let apiName: String
    let target: Target
    let path: [Component]
}
