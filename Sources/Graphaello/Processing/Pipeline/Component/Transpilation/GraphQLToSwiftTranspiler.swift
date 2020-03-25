//
//  GraphQLToSwiftTranspiler.swift
//  
//
//  Created by Mathias Quintero on 12/18/19.
//

import Foundation
import SwiftSyntax

protocol GraphQLToSwiftTranspiler {
    func expression(from value: GraphQLValue?,
                    for type: Schema.GraphQLType.Field.TypeReference,
                    using api: API) throws -> ExprSyntaxProtocol?

    func expression(from value: GraphQLValue,
                    for type: Schema.GraphQLType.Field.TypeReference,
                    using api: API) throws -> ExprSyntaxProtocol
}
