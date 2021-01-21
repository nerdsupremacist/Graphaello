import Foundation
import PathKit

struct SettingsKey<Key> {
    fileprivate let key: String
    fileprivate let read: (UserDefaults) -> Key?
    fileprivate let write: (UserDefaults, Key) -> ()
}

extension SettingsKey where Key == Int {

    static let lastRunHash = SettingsKey<Int>(key: "last_run_hash")

    fileprivate init(key: String) {
        self.init(key: key, read: { $0.integer(forKey: key) }, write: { $0.set($1, forKey: key) })
    }

}

extension SettingsKey where Key == [String] {

    fileprivate static let usedKeys = SettingsKey<[String]>(key: "_used_keys")

    fileprivate init(key: String) {
        self.init(key: key, read: { $0.stringArray(forKey: key) }, write: { $0.set($1, forKey: key) })
    }

}

public class PersistentCache<Key: Hashable> {
    private let folder: Path
    private let index: Path
    private let capacity: Int
    private let hasher: Hasher = Hasher.constantAccrossExecutions()
    private var hashStore: OrderedSet<Int>
    private let settings: UserDefaults?

    convenience init(project: Project, capacity: Int) throws {
        let parentFolder = Path(NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!)

        var hasher = Hasher.constantAccrossExecutions()
        project.path.hash(into: &hasher)
        let folder = parentFolder + "graphaello" + "\(hasher.finalize())"

        try self.init(folder: folder, capacity: capacity)
    }

    public init(folder: Path, capacity: Int) throws {
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

        settings = UserDefaults(suiteName: folder.string.camelized)
    }

    deinit {
        try? store()
    }

    public func clear() throws {
        if let settings = settings {
            for key in usedKeys {
                settings.removeObject(forKey: key)
            }
            usedKeys = []
        }
        try folder.delete()
    }

    public func load(key: Key) throws -> Data? {
        let hash = computeHash(of: key)
        let file = self.file(for: hash)
        if file.exists {
            assert(hashStore.contains(hash))
            use(hash: hash)
            return try file.read()
        } else {
            return nil
        }
    }

    public func store(data: Data, for key: Key) throws {
        let hash = computeHash(of: key)

        if hashStore.contains(hash) && hashStore.count >= capacity {
            try evictLeastRecentlyUsed()
        }

        use(hash: hash)
        try file(for: hash).write(data)
    }
}

extension PersistentCache {

    private var usedKeys: Set<String> {
        get {
            self[.usedKeys].map(Set.init) ?? []
        }
        set {
            guard let settings = settings else { return }
            if !newValue.isEmpty {
                SettingsKey.usedKeys.write(settings, Array(newValue))
            } else {
                settings.removeObject(forKey: SettingsKey.usedKeys.key)
            }
        }
    }

    subscript<T>(key: SettingsKey<T>) -> T? {
        get {
            guard let settings = settings else { return nil }
            return key.read(settings)
        }
        set {
            guard let settings = settings else { return }
            if let newValue = newValue {
                key.write(settings, newValue)
                usedKeys.formUnion([key.key])
            } else {
                settings.removeObject(forKey: key.key)
                usedKeys.subtract([key.key])
            }
        }
    }

}

extension PersistentCache {

    private struct StringCannotBeStoredInCacheError : Error {
        let string: String
        let encoding: String.Encoding
    }

    public func load(key: Key, encoding: String.Encoding = .utf8) throws -> String? {
        return try load(key: key).flatMap { String(data: $0, encoding: encoding) }
    }

    public func store(string: String, for key: Key, encoding: String.Encoding = .utf8) throws {
        guard let data = string.data(using: encoding) else { throw StringCannotBeStoredInCacheError(string: string, encoding: encoding) }
        try store(data: data, for: key)
    }

}

extension PersistentCache {

    public func tryCache(key: Key, encoding: String.Encoding = .utf8, builder: () throws -> String) throws -> String {
        if let cached = try load(key: key, encoding: encoding) {
            return cached
        }

        let computed = try builder()
        try store(string: computed, for: key, encoding: encoding)
        return computed
    }

}

extension PersistentCache {

    private func file(for hash: Int) -> Path {
        return folder + String(hash)
    }

    private func computeHash(of key: Key) -> Int {
        var hasher = self.hasher
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

extension Hasher {
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

    static func constantAccrossExecutions() -> Hasher {
        let offset = MemoryLayout<Hasher>.size - MemoryLayout<_State>.size
        var hasher = Hasher()
        withUnsafeMutableBytes(of: &hasher) { pointer in
            pointer.baseAddress!.storeBytes(of: _State(), toByteOffset: offset, as: _State.self)
        }
        return hasher
    }
}

extension Optional {
    func tryCache<Key : Hashable>(key: Key,
                                  encoding: String.Encoding = .utf8,
                                  builder: () throws -> String) throws -> String where Wrapped == PersistentCache<Key> {
        guard let wrapped = self else { return try builder() }
        return try wrapped.tryCache(key: key, encoding: encoding, builder: builder)
    }
}
