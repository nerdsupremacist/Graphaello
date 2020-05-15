import Foundation

extension Schema.GraphQLType {

    struct InputField: Codable, Hashable {
        let name: String
        let type: Field.TypeReference

        @OptionalParsed<GraphQLValue.Lexer, GraphQLValue>
        var defaultValue: GraphQLValue?
    }

}
