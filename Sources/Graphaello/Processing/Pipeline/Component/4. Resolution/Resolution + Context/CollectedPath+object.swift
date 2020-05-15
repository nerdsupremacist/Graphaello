import Foundation

extension CollectedPath.Valid {

    func object(propertyName: String) -> GraphQLObject {
        switch self {

        case .scalar(let field):
            return GraphQLObject(components: [field : .scalar],
                                 fragments: [],
                                 typeConditionals: [:])

        case .object(let field, let valid):
            return GraphQLObject(components: [field : .object(valid.object(propertyName: propertyName))],
                                 fragments: [],
                                 typeConditionals: [:])

        case .fragment(let fragment):
            return GraphQLObject(components: [:], fragments: [fragment], typeConditionals: [:])

        case .connection(let connection):
            return GraphQLObject(components: [:], fragments: [connection.fragment], typeConditionals: [:])

        case .typeConditional(let type, .valid(let valid)):
            let conditional = GraphQLTypeConditional(type: type, object: valid.object(propertyName: propertyName))
            return GraphQLObject(components: [:],
                                 fragments: [],
                                 typeConditionals: [type.name : conditional])

        case .typeConditional(_, .empty):
            fatalError()

        }
    }
    
}
