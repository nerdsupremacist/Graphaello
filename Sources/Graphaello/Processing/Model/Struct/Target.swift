import Foundation

enum Target: Equatable, Hashable {
    case query
    case mutation
    case object(String)
}
