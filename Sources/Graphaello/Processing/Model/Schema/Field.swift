import Foundation

extension Schema.GraphQLType {

    struct Field: Codable, Equatable, Hashable {
        enum CodingKeys: String, CodingKey {
            case name
            case arguments = "args"
            case type
        }

        let name: String
        let arguments: [Argument]
        let `type`: TypeReference
    }

}
