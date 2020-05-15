import Foundation

protocol ContextProtocol {
    func merge(with context: Context) -> Context
}

func + (lhs: ContextProtocol, rhs: ContextProtocol) -> Context {
    return Context {
        lhs
        rhs
    }
}
