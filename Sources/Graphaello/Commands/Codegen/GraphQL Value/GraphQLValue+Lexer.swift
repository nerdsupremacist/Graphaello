//
//  File.swift
//  
//
//  Created by Mathias Quintero on 12/18/19.
//

import Foundation
import Ogma

extension GraphQLValue {

    enum Lexer: GeneratorLexer {
        typealias Token = GraphQLValue.Token

        static let generators: Generators = [
            RegexTokenGenerator(pattern: "\\{").map(to: .openCurlyBracket),
            RegexTokenGenerator(pattern: "\\}").map(to: .closeCurlyBracket),
            RegexTokenGenerator(pattern: "\\[").map(to: .openSquareBracket),
            RegexTokenGenerator(pattern: "\\]").map(to: .closeSquareBracket),
            RegexTokenGenerator(pattern: ",").map(to: .comma),
            RegexTokenGenerator(pattern: ":").map(to: .colon),
            RegexTokenGenerator(pattern: "true\\b").map(to: .true),
            RegexTokenGenerator(pattern: "false\\b").map(to: .false),
            RegexTokenGenerator(pattern: "null\\b").map(to: .null),
            RegexTokenGenerator(pattern: "[a-zA-Z][a-zA-Z\\-_0-9]*").map(Token.identifier),

            StringLiteralTokenGenerator().map(Token.string),
            DoubleLiteralTokenGenerator().map(Token.double),
            IntLiteralTokenGenerator().map(Token.int),

            WhiteSpaceTokenGenerator().ignore(),
        ]
    }

}
