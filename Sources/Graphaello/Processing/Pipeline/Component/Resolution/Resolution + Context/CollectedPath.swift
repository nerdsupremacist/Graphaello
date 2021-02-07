import Foundation

enum CollectedPath {
    indirect enum Valid {
        case typeConditional(Schema.GraphQLType, CollectedPath)
        case scalar(Field)
        case object(Field, Valid)
        case fragment(GraphQLFragment)
        case connection(GraphQLConnectionFragment)
    }
    
    case valid(Valid)
    case empty
}

extension CollectedPath {
    
    
    static func + (lhs: CollectedPath, rhs: CollectedPath.Valid) -> CollectedPath {
        switch lhs {
        case .valid(let valid):
            return .valid(valid + rhs)
        case .empty:
            return .valid(rhs)
        }
    }
    
}

extension CollectedPath.Valid {
    

    static func + (lhs: CollectedPath.Valid, rhs: CollectedPath.Valid) -> CollectedPath.Valid {
        switch lhs {
        case .scalar(let field):
            return .object(field, rhs)
        case .object(let field, let valid):
            return .object(field, valid + rhs)
        case .typeConditional(let type, let path):
            return .typeConditional(type, path + rhs)
        case .fragment, .connection:
            fatalError("Unexpected extra value appended to fragment")
        }
        
    }
    
}
