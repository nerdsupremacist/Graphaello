//
//  GraphQLField.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 06.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

enum Field: Equatable, Hashable {
    case direct(String)
    case call(String, [String : GraphQLPath.Component.Argument])
}
