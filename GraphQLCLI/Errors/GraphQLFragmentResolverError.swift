//
//  GraphQLFragmentResolverError.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 06.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

enum GraphQLFragmentResolverError: Error {
    case failedToDecodeAnyOfTheStructsDueToPossibleRecursion([Struct], resolved: [GraphQLStruct])
    case cannotResolveFragmentOrQueryWithEmptyPath(GraphQLPath)
    case cannotIncludeFragmentsInsideAQuery(GraphQLFragment)
    case cannotQueryDataFromTwoAPIsFromTheSameStruct(API, API)
}
