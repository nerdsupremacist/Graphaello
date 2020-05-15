import Foundation
import SwiftSyntax

enum Operation: Equatable {
    case flatten
    case compactMap
    case nonNull
    case withDefault(ExprSyntax)

    static func == (lhs: Operation, rhs: Operation) -> Bool {
        switch (lhs, rhs) {
        case (.flatten, .flatten):
            return true
        case (.compactMap, .compactMap):
            return true
        case (.nonNull, .nonNull):
            return true
        case (.withDefault(let lhs), .withDefault(let rhs)):
            return lhs.description == rhs.description
        default:
            return false
        }
    }
}
