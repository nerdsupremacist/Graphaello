import Foundation

extension CollectedPath.Valid {

    func queryComponents(propertyName: String) throws -> [GraphQLField : GraphQLComponent] {
        switch self {
        case .scalar(let field):
            return [GraphQLField(field: field, alias: nil) : .scalar]
        case .object(let field, let valid):
            return [GraphQLField(field: field, alias: nil) : .object(valid.object(propertyName: propertyName))]
        case .connection(let connection):
            throw GraphQLFragmentResolverError.cannotIncludeFragmentsInsideAQuery(connection.fragment)
        case .fragment(let fragment):
            throw GraphQLFragmentResolverError.cannotIncludeFragmentsInsideAQuery(fragment)
        case .typeConditional(let type, _):
            throw GraphQLFragmentResolverError.cannotDowncastQueryToType(type)
        }
    }
    
}
