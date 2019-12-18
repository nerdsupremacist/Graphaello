//
//  Argument.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 12/4/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import Ogma

extension Schema.GraphQLType.Field {

    struct Argument: Codable, Equatable, Hashable {
        let name: String

        @OptionalParsed<GraphQLValue.Lexer, GraphQLValue>
        var defaultValue: GraphQLValue?

        let `type`: TypeReference
    }

}

@propertyWrapper
struct OptionalParsed<Lexer: LexerProtocol, Value: Parsable & Hashable>: Codable, Hashable where Lexer.Token == Value.Token {
    private let stringRepresentation: String?
    var wrappedValue: Value?

    private init(stringRepresentation: String?) throws {
        self.stringRepresentation = stringRepresentation
        self.wrappedValue = try stringRepresentation.map { try Value.parse($0, using: Lexer.self) }
    }

    init(from decoder: Decoder) throws {
        try self.init(stringRepresentation: Optional<String>(from: decoder))
    }

    func encode(to encoder: Encoder) throws {
        try stringRepresentation.encode(to: encoder)
    }
}
