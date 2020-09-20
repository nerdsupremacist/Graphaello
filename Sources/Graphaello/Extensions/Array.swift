import Foundation

extension Target {
    
    func type(in api: API) throws -> Schema.GraphQLType {
        switch self {
        case .query:
            return api.query
        case .mutation:
            return try api.mutation ?! GraphQLPathValidationError.typeNotFound("Mutation", api: api)
        case .object(let name):
            return try api.types[name] ?! GraphQLPathValidationError.typeNotFound(name, api: api)
        }
    }
    
}

extension Array where Element == API {
    
    subscript(api: String) -> Element? {
        return first { $0.name == api }
    }
    
}

extension Array where Element == Schema.GraphQLType {
    
    subscript(name: String) -> Element? {
        let name = name.upperCamelized
        return first { $0.name.upperCamelized == name }
    }
    
}

extension Array where Element == Schema.GraphQLType.Field {
    
    subscript(name: String) -> Element? {
        let name = name.camelized
        return first { $0.name.camelized == name }
    }
    
}

extension Array where Element == Schema.TypeReference {

    subscript(name: String) -> Element? {
        let name = name.upperCamelized
        return first { $0.name.upperCamelized == name }
    }

}

extension Array where Element == Schema.GraphQLType.Field.Argument {

    subscript(name: String) -> Schema.GraphQLType.Field.Argument? {
        let name = name.camelized
        return first { $0.name.camelized == name }
    }

}
