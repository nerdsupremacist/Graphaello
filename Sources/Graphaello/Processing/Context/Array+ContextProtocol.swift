import Foundation

extension Array: ContextProtocol where Element: ContextProtocol {
    
    func merge(with context: Context) -> Context {
        return reduce(context) { $1.merge(with: $0) }
    }
    
}
