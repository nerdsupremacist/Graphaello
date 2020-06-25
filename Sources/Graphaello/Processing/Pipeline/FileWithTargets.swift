
import Foundation
import SourceKittenFramework

struct WithTargets<Value> {
    let value: Value
    let targets: [String]
}

extension WithTargets {
    
    func map<T>(_ transform: (Value) throws -> T) rethrows -> WithTargets<T> {
        return WithTargets<T>(value: try transform(value), targets: targets)
    }
    
    func compactMap<T>(_ transform: (Value) throws -> T?) rethrows -> WithTargets<T>? {
        return try transform(value).map { WithTargets<T>(value: $0, targets: targets) }
    }
    
}
