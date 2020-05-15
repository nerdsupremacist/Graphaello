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
