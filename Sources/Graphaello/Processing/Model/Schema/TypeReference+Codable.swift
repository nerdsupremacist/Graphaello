import Foundation

extension Schema.GraphQLType.Field.TypeReference: Codable {
    enum CodingKeys: String, CodingKey {
        case ofType
    }

    init(from decoder: Decoder) throws {
        let definition = try Schema.GraphQLType.Field.TypeReference.Definition(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if container.contains(.ofType),
            let ofType = try container.decode(Schema.GraphQLType.Field.TypeReference?.self, forKey: .ofType) {

            self = .complex(definition,
                            ofType: ofType)
        } else {
            self = .concrete(definition)
        }
    }

    func encode(to encoder: Encoder) throws {
        switch self {
        case .concrete(let definition):
            try definition.encode(to: encoder)
        case .complex(let definition, let other):
            try definition.encode(to: encoder)
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(other, forKey: .ofType)
        }
    }
}
