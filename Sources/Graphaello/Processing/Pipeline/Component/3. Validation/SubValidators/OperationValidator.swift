//
//  OperationTypeValidator.swift
//  
//
//  Created by Mathias Quintero on 1/15/20.
//

import Foundation

protocol OperationTypeValidator {
    func validate(operation: Operation,
                  using context: ComponentValidation.Context) throws -> Schema.GraphQLType.Field.TypeReference
}
