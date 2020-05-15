import Foundation

@_functionBuilder
struct ContextBuilder {

    static func buildBlock() -> ContextProtocol {
        return Context.empty
    }
    
    static func buildBlock(_ context: ContextProtocol) -> ContextProtocol {
        return context
    }
    
    static func buildBlock(_ context: ContextProtocol...) -> ContextProtocol {
        return context.map { AnyContextProtocol(context: $0) }
    }
    
}

extension Context {
    
    init(@ContextBuilder context: () throws -> ContextProtocol) rethrows {
        self = try context().merge(with: .empty)
    }
    
}
