import Foundation

enum Target: Equatable {
    case query
    case mutation
    case object(String)
}
