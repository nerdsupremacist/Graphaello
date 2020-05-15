import Foundation
import Ogma

extension GraphQLValue {

    enum Lexer: GeneratorLexer {
        typealias Token = GraphQLValue.Token

        static let generators: Generators = [
            RegexTokenGenerator(pattern: #"\{"#).map(to: .openCurlyBracket),
            RegexTokenGenerator(pattern: #"\}"#).map(to: .closeCurlyBracket),
            RegexTokenGenerator(pattern: #"\["#).map(to: .openSquareBracket),
            RegexTokenGenerator(pattern: #"\]"#).map(to: .closeSquareBracket),
            RegexTokenGenerator(pattern: ",").map(to: .comma),
            RegexTokenGenerator(pattern: ":").map(to: .colon),
            RegexTokenGenerator(word: "true").map(to: .value(.bool(true))),
            RegexTokenGenerator(word: "false").map(to: .value(.bool(true))),
            RegexTokenGenerator(word: "null").map(to: .value(.null)),
            RegexTokenGenerator(pattern: #"[a-zA-Z][a-zA-Z\-_0-9]*"#).map { .value(.identifier($0)) },

            StringLiteralTokenGenerator().map { .value(.string($0)) },
            DoubleLiteralTokenGenerator().map { .value(.double($0)) },
            IntLiteralTokenGenerator().map { .value(.int($0)) },

            WhiteSpaceTokenGenerator().ignore(),
        ]
    }

}
