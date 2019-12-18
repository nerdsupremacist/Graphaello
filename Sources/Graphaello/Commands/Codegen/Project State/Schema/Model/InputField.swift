//
//  InputField.swift
//  
//
//  Created by Mathias Quintero on 12/17/19.
//

import Foundation

extension Schema.GraphQLType {

    struct InputField: Codable {
        let name: String
        let type: Field.TypeReference

        @OptionalParsed<GraphQLValue.Lexer, GraphQLValue>
        var defaultValue: GraphQLValue?
    }

}
