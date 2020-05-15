import Foundation

indirect enum GraphQLComponent: Hashable {
    case scalar
    case object(GraphQLObject)
}

extension GraphQLComponent {

    var arguments: OrderedSet<GraphQLArgument> {
        switch self {
        case .object(let object):
            return object.arguments
        case .scalar:
            return []
        }
    }

}

extension GraphQLComponent {
    
    static func + (lhs: GraphQLComponent, rhs: GraphQLComponent) -> GraphQLComponent {
        switch (lhs, rhs) {
        case (.scalar, .scalar):
            return .scalar
        case (.object(let lhs), .object(let rhs)):
            return .object(lhs + rhs)
        default:
            fatalError()
        }
    }
    
}
