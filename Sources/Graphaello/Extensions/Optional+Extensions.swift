import Foundation

infix operator ?!: NilCoalescingPrecedence

extension Optional {

    static func ?!(lhs: Wrapped?, rhs: @autoclosure () -> Error) throws -> Wrapped {
        guard let lhs = lhs else {
            throw rhs()
        }
        return lhs
    }
    
    static func ?!(lhs: Wrapped?, rhs: @autoclosure () -> Never) -> Wrapped {
        guard let lhs = lhs else { rhs() }
        return lhs
    }

}
