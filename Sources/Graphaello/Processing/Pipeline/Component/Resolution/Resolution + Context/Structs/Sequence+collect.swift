import Foundation

extension Sequence {
    
    func collect<Value>(transform: (Element) throws -> StructResolution.Result<Value>) rethrows -> StructResolution.Result<[Value]> {
        var collected = [Value]()
        for element in self {
            switch try transform(element) {
            case .resolved(let value):
                collected.append(value)
            case .missingFragment:
                return .missingFragment
            }
        }
        return .resolved(collected)
    }
    
}
