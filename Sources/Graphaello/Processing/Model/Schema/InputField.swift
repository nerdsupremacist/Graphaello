import Foundation
import GraphQLSyntax

extension Schema.GraphQLType {

    struct InputField: Codable, Hashable {
        let name: String
        let type: Field.TypeReference

        @OptionalParsed<GraphQL.Value.Parser>
        var defaultValue: GraphQL.Value?
    }

}
