//
//  GraphQLPathValidationError.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 04.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

enum GraphQLPathValidationError: Error {
    case apiNotFound(String, apis: [String])
    case typeNotFound(String, api: String)
    case cannotCallUseComponentForScalar(GraphQLPath.Component, type: Schema.GraphQLType)
    case fieldNotFoundInType(String, type: Schema.GraphQLType)
}
