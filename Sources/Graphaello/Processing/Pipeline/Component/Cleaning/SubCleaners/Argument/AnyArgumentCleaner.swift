import Foundation

extension ArgumentCleaner {

    func any() -> AnyArgumentCleaner<Value> {
        return AnyArgumentCleaner(self)
    }

}

struct AnyArgumentCleaner<T>: ArgumentCleaner {
    let _clean: (T, Cleaning.Argument.Context) throws -> Cleaning.Argument.Result<T>

    init<C: ArgumentCleaner>(_ cleaner: C) where C.Value == T {
        _clean = cleaner.clean
    }

    func clean(resolved: T, using context: Cleaning.Argument.Context) throws -> Cleaning.Argument.Result<T> {
        return try _clean(resolved, context)
    }
}
