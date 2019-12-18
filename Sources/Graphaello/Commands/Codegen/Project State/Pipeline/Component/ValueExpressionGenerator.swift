//
//  ValueExpressionGenerator.swift
//  
//
//  Created by Mathias Quintero on 12/18/19.
//

import Foundation
import SwiftSyntax

protocol ValueExpressionGenerator {
    func expression(from value: GraphQLValue,
                    for type: Schema.GraphQLType.Field.TypeReference,
                    using api: API) throws -> ExprSyntax
}
