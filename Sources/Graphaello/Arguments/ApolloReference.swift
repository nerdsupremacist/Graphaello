import Foundation
import CLIKit

enum ApolloReference: String {
    case binary
    case derivedData
}

extension ApolloReference: CommandArgumentValue {
    
    var description: String {
        switch self {
        case .binary:
            return "Binary Command Line Tool"
        case .derivedData:
            return "Command Line Tool in Apollo's derived data"
        }
    }
    
    init(argumentValue: String) throws {
        self = try ApolloReference(rawValue: argumentValue) ?! ArgumentError.invalidApolloReference(argumentValue)
    }
    
}
