
import Foundation
import Runtime
import PathKit

class FileCache<Key: Hashable> {
    private let folder: Path
    private let index: Path
    private let capacity: Int
    private var hashStore: OrderedSet<Int>

    init(folder: Path, capacity: Int) throws {
        self.folder = folder
        self.index = folder + ".index"
        self.capacity = capacity

        if !folder.exists {
            try folder.mkpath()
        }

        if index.exists {
            let bytes = Array(try index.read())
            hashStore = OrderedSet(bytes.rebound(to: Int.self))
        } else {
            hashStore = []
        }
    }

    deinit {
        try! store()
    }

    func load(key: Key) throws -> Data? {
        let hash = try computeHash(of: key)
        let file = self.file(for: hash)
        if file.exists {
            assert(hashStore.contains(hash))
            use(hash: hash)
            return try file.read()
        } else {
            return nil
        }
    }

    func store(data: Data, for key: Key) throws {
        let hash = try computeHash(of: key)

        if hashStore.contains(hash) && hashStore.count >= capacity {
            try evictLeastRecentlyUsed()
        }

        use(hash: hash)
        try file(for: hash).write(data)
    }
}

extension FileCache {

    struct StringCannotBeStoredInCacheError : Error {
        let string: String
        let encoding: String.Encoding
    }

    func load(key: Key, encoding: String.Encoding = .utf8) throws -> String? {
        return try load(key: key).flatMap { String(data: $0, encoding: encoding) }
    }

    func store(string: String, for key: Key, encoding: String.Encoding = .utf8) throws {
        guard let data = string.data(using: encoding) else { throw StringCannotBeStoredInCacheError(string: string, encoding: encoding) }
        try store(data: data, for: key)
    }

}

extension FileCache {

    func tryCache(key: Key, encoding: String.Encoding = .utf8, builder: () throws -> String) throws -> String {
        if let cached = try load(key: key, encoding: encoding) {
            return cached
        }

        let computed = try builder()
        try store(string: computed, for: key, encoding: encoding)
        return computed
    }

}

extension Optional {
    func tryCache<Key : Hashable>(key: Key,
                                  encoding: String.Encoding = .utf8,
                                  builder: () throws -> String) throws -> String where Wrapped == FileCache<Key> {
        guard let wrapped = self else { return try builder() }
        return try wrapped.tryCache(key: key, encoding: encoding, builder: builder)
    }
}

extension FileCache {

    private func file(for hash: Int) -> Path {
        return folder + String(hash)
    }

    private func computeHash(of key: Key) throws -> Int {
        var hasher = try reliableHasher()
        key.hash(into: &hasher)
        return hasher.finalize()
    }

    private func use(hash: Int) {
        hashStore.remove(hash)
        hashStore.append(hash)
    }

    private func store() throws {
        let data = Data(buffer: hashStore.rebound(to: UInt8.self))
        try index.write(data)
    }

    private func evictLeastRecentlyUsed() throws {
        let leastRecentlyUsed = hashStore.removeFirst()
        let file = self.file(for: leastRecentlyUsed)
        try file.delete()
    }

}

extension Collection {

    fileprivate func rebound<T>(to type: T.Type) -> UnsafeBufferPointer<T> {
        let pointer = UnsafeMutableBufferPointer<Element>.allocate(capacity: count)
        _ = pointer.initialize(from: self)
        let rawPointer = UnsafeRawPointer(pointer.baseAddress!)
        let size = count * MemoryLayout<Element>.size / MemoryLayout<T>.size
        return UnsafeBufferPointer(start: rawPointer.assumingMemoryBound(to: type), count: size)
    }

    fileprivate func rebound<T>(to type: T.Type) -> [T] {
        let pointer = self.rebound(to: type) as UnsafeBufferPointer<T>
        let rebound = Array(pointer)
        pointer.deallocate()
        return rebound
    }

}

// Stolen from https://github.com/apple/swift/blob/master/stdlib/public/core/SipHash.swift
// in order to replicate the exact format in bytes
private struct _State {
  private var v0: UInt64 = 0x736f6d6570736575
  private var v1: UInt64 = 0x646f72616e646f6d
  private var v2: UInt64 = 0x6c7967656e657261
  private var v3: UInt64 = 0x7465646279746573
  private var v4: UInt64 = 0
  private var v5: UInt64 = 0
  private var v6: UInt64 = 0
  private var v7: UInt64 = 0
}

private func reliableHasher() throws -> Hasher {
    return try createInstance { coreProperty in
        return try createInstance(of: coreProperty.type) { property in
            switch property.name {
            case "_buffer":
                return try createInstance(of: property.type)
            case "_state":
                return withUnsafeBytes(of: _State()) { $0.baseAddress!.unsafeLoad(as: property.type) }
            default:
                fatalError()
            }
        }
    }
}
