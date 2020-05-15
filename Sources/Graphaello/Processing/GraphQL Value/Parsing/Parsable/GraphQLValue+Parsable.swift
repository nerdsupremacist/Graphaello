import Foundation
import Ogma

extension GraphQLValue: Parsable {

    public static let parser: AnyParser<Token, GraphQLValue> = Array<GraphQLValue>.map(GraphQLValue.array) ||
        Dictionary<String, GraphQLValue>.map(GraphQLValue.dictionary) ||
        AnyParser.consuming { token in
            switch token {
            case .value(let value):
                return value
            case .openCurlyBracket, .closeCurlyBracket, .openSquareBracket, .closeSquareBracket, .comma, .colon:
                return nil
            }
        }

}
