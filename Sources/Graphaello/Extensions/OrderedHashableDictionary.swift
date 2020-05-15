import Foundation

@propertyWrapper
class OrderedHashableDictionary<Key : Hashable & Comparable, Value: Hashable>: Hashable {
    var wrappedValue: [Key : Value]

    init(wrappedValue: [Key : Value]) {
        self.wrappedValue = wrappedValue
    }

    static func == (lhs: OrderedHashableDictionary<Key, Value>, rhs: OrderedHashableDictionary<Key, Value>) -> Bool {
        return lhs.wrappedValue == rhs.wrappedValue
    }

    func hash(into hasher: inout Hasher) {
        let sorted = wrappedValue.sorted { $0.key < $1.key }

        // Based from: https://github.com/apple/swift/blob/master/stdlib/public/core/Dictionary.swift
        var commutativeHash = 0
        for (k, v) in sorted {
            var elementHasher = hasher
            elementHasher.combine(k)
            elementHasher.combine(v)
            commutativeHash ^= elementHasher.finalize()
        }
        hasher.combine(commutativeHash)
    }
}
