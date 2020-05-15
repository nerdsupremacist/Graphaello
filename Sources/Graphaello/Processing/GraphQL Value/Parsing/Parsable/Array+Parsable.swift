import Foundation
import Ogma

extension Array: Parsable where Element == GraphQLValue {
    public typealias Token = GraphQLValue.Token

    public static let parser = GraphQLValue
           .separated(by: .comma, allowsEmpty: true)
           .wrapped(by: .openSquareBracket, and: .closeSquareBracket)
}
