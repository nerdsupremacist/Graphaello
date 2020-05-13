
import Foundation
import Stencil

extension CodeTransformable where Self: Hashable {

    func cached(using cache: PersistentCache<AnyHashable>?) -> CachedCodeTransformable<Self> {
        return CachedCodeTransformable(code: self, cache: cache)
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
