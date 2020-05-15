import Foundation

struct Schema: Codable {
    let types: [GraphQLType]
    let queryType: TypeReference
    let mutationType: TypeReference?
}
