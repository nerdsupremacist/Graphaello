import Foundation
import SwiftSyntax

struct GraphQLArgument: Hashable {
    let name: String
    let field: Schema.GraphQLType.Field
    let type: Schema.GraphQLType.Field.TypeReference
    let defaultValue: ExprSyntax?
    let argument: Argument

    static func == (lhs: GraphQLArgument, rhs: GraphQLArgument) -> Bool {
        return lhs.name == rhs.name &&
            lhs.field == rhs.field &&
            lhs.type == rhs.type &&
            lhs.defaultValue?.description == rhs.defaultValue?.description &&
            lhs.argument == rhs.argument
    }

    static func ~= (lhs: GraphQLArgument, rhs: GraphQLArgument) -> Bool {
        return lhs.name == rhs.name &&
            lhs.type == rhs.type &&
            lhs.defaultValue?.description == rhs.defaultValue?.description &&
            lhs.argument == rhs.argument
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(field)
        hasher.combine(type)
        hasher.combine(defaultValue?.description)
        hasher.combine(argument)
    }
}

extension GraphQLArgument {

    var isHardCoded: Bool {
        switch argument {
        case .value:
            return true
        case .argument:
            return false
        }
    }

}
