import Foundation
import GraphQLSyntax

extension Schema.GraphQLType.Field {

    struct Argument: Codable, Equatable, Hashable {
        let name: String

        @OptionalParsed<GraphQL.Value.Parser>
        var defaultValue: GraphQL.Value?

        let `type`: TypeReference
    }

}

extension GraphQL.Value.Parser: InstantiableParser { }
