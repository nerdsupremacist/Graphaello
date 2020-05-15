import Foundation

extension Schema.GraphQLType.Field.TypeReference {

    struct Definition: Codable, Equatable, Hashable {
        let kind: Schema.GraphQLType.Kind
        let name: String?
    }

}
