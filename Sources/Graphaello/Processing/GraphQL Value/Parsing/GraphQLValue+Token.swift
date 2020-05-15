import Foundation
import Ogma

extension GraphQLValue {

    public enum Token: TokenProtocol {
        case openCurlyBracket
        case closeCurlyBracket

        case openSquareBracket
        case closeSquareBracket

        case comma
        case colon

        case value(GraphQLValue)
    }

}
