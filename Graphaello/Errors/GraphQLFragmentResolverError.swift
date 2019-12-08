//
//  GraphQLFragmentResolverError.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 06.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

enum GraphQLFragmentResolverError: Error {
    case invalidTypeNameForFragment(String)
    case failedToDecodeAnyOfTheStructsDueToPossibleRecursion([Struct<Stage.Validated>])
    case cannotResolveFragmentOrQueryWithEmptyPath(Stage.Validated.Path)
    case cannotIncludeFragmentsInsideAQuery(GraphQLFragment)
    case cannotQueryDataFromTwoAPIsFromTheSameStruct(API, API)
}
