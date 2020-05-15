import Foundation

struct ContextKeyAssignment<T>: ContextProtocol {
    let key: Context.Key<T>
    let value: T
}

extension Context.Key {
    
    static func ~> (lhs: Context.Key<T>, rhs: @autoclosure () throws -> T) rethrows -> ContextKeyAssignment<T> {
        return ContextKeyAssignment(key: lhs, value: try rhs())
    }
    
}
