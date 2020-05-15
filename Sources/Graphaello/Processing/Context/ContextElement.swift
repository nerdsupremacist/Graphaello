import Foundation

protocol ContextElement: ContextProtocol {
    static var key: Context.Key<Self> { get }
}

extension ContextElement {
    
    func merge(with context: Context) -> Context {
        return (Self.key ~> self).merge(with: context)
    }
    
}

extension Context {

    subscript<T: ContextElement>(type: T.Type) -> T {
        return self[type.key]
    }

}
