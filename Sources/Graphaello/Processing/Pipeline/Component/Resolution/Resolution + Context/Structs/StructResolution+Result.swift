import Foundation

extension StructResolution {
    
    enum Result<Value> {
        case resolved(Value)
        case missingFragment
    }
    
    enum StructResult<Value> {
        case resolved(Value)
        case missingFragment(Struct<Stage.Validated>)
    }
    
}

extension StructResolution.Result {
    
    func map<T>(transform: (Value) throws -> T) rethrows -> StructResolution.Result<T> {
        switch self {
        case .resolved(let value):
            return .resolved(try transform(value))
        case .missingFragment:
            return .missingFragment
        }
    }
    
    func flatMap<T>(transform: (Value) throws -> StructResolution.Result<T>) rethrows -> StructResolution.Result<T> {
        switch self {
        case .resolved(let value):
            return try transform(value)
        case .missingFragment:
            return .missingFragment
        }
    }
    
}

extension StructResolution.Result {
    
    func map(to validated: Struct<Stage.Validated>) -> StructResolution.StructResult<Value> {
        switch self {
        case .resolved(let value):
            return .resolved(value)
        case .missingFragment:
            return .missingFragment(validated)
        }
    }
    
}
