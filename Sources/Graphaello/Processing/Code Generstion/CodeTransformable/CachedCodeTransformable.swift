import Foundation
import Stencil

extension CodeTransformable where Self: Hashable {

    func cached(using cache: PersistentCache<AnyHashable>?) -> CachedCodeTransformable<Self> {
        return CachedCodeTransformable(code: self, cache: cache)
    }

    func cached<T : Hashable>(alongWith other: T, using cache: PersistentCache<AnyHashable>?) -> CachedCodeTransformable<AdditionalHashedCode<Self, T>> {
        return AdditionalHashedCode(code: self, other: other).cached(using: cache)
    }

}

struct CachedCodeTransformable<Code : CodeTransformable & Hashable> : CodeTransformable {
    let code: Code
    let cache: PersistentCache<AnyHashable>?

    func code(using context: Stencil.Context, arguments: [Any?]) throws -> String {
        return try cache.tryCache(key: code) {
            return try code.code(using: context, arguments: arguments)
        }
    }
}

struct AdditionalHashedCode<Code : CodeTransformable & Hashable, Other: Hashable> : CodeTransformable, Hashable {
    let code: Code
    let other: Other

    func code(using context: Stencil.Context, arguments: [Any?]) throws -> String {
        return try code.code(using: context, arguments: arguments)
    }
}
