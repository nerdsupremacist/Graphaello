import Foundation

extension Schema.GraphQLType {

    enum Kind: String, Codable, Equatable, Hashable {
        case scalar = "SCALAR"
        case object = "OBJECT"
        case list = "LIST"
        case nonNull = "NON_NULL"
        case `enum` = "ENUM"
        case interface = "INTERFACE"
        case inputObject = "INPUT_OBJECT"
        case union = "UNION"
    }
    
}

extension Schema.GraphQLType.Kind {


    var isFragment: Bool {
        switch self {
        case .object, .interface, .union:
            return true
        case .scalar, .enum, .nonNull, .list, .inputObject:
            return false
        }
    }

}
