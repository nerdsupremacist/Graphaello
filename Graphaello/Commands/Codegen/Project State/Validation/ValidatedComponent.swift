//
//  GraphQLPath+ValidatedComponent.swift
//  Graphaello
//
//  Created by Mathias Quintero on 12/7/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

struct ValidatedComponent {
    let fieldType: Schema.GraphQLType.Field.TypeReference
    let underlyingType: Schema.GraphQLType
    let component: StandardComponent
}
