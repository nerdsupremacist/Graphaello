import Foundation
import Stencil

extension CodeTransformable where Self: Hashable {

    func cached(using cache: PersistentCache<AnyHashable>?) -> CachedCodeTransformable<Self> {
        return CachedCodeTransformable(code: self, cache: cache)
    }

    func cached<T : Hashable>(alongWith other: T, using cache: PersistentCache<AnyHashable>?) -> CachedCodeTransformable<AdditionalHashedCode<Self, T>> {
        return AdditionalHashedCode(code: self, other: other).cached(using: cache)
    }

    func cached<C0 : Hashable, C1: Hashable>(
        alongWith c0: C0,
        _ c1: C1,
        using cache: PersistentCache<AnyHashable>?
    ) -> CachedCodeTransformable<AdditionalHashedCode<Self, ComposedHashable<C0, C1>>> {

        return AdditionalHashedCode(code: self, other: ComposedHashable(c0: c0, c1: c1)).cached(using: cache)
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


struct ComposedHashable<C0 : Hashable, C1 : Hashable>: Hashable {
    let c0: C0
    let c1: C1
}
