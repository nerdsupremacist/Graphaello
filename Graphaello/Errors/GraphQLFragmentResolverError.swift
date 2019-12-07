//
//  GraphQLFragmentResolverError.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 06.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

enum GraphQLFragmentResolverError: Error {
    case failedToDecodeAnyOfTheStructsDueToPossibleRecursion([Struct<ValidatedComponent>], resolved: [GraphQLStruct])
    case cannotResolveFragmentOrQueryWithEmptyPath(GraphQLPath<ValidatedComponent>)
    case cannotIncludeFragmentsInsideAQuery(GraphQLFragment)
    case cannotQueryDataFromTwoAPIsFromTheSameStruct(API, API)
}
