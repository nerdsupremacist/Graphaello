//
//  Context.swift
//  
//
//  Created by Mathias Quintero on 31.12.19.
//

import Foundation

struct Context {
    class AnyKey: NSObject {
        fileprivate override init() {
            super.init()
        }
    }
    
    final class Key<T>: AnyKey {
        override init() {
            super.init()
        }
    }
    
    fileprivate let dictionary: [AnyKey : Any]
    
    fileprivate init(dictionary: [AnyKey : Any]) {
        self.dictionary = dictionary
    }
    
    subscript<T>(key: Key<T>) -> T {
        let value = dictionary[key] ?! fatalError("Key not populated")
        return value as? T ?! fatalError("Value in key does not match type")
    }
}

extension Context {
    
    static let empty = Context(dictionary: [:])
    
}

extension Context: ContextProtocol {
    
    func merge(with context: Context) -> Context {
        return Context(dictionary: context.dictionary.merging(dictionary) { $1 })
    }
    
}

extension ContextKeyAssignment {
    
    func merge(with context: Context) -> Context {
        return Context(dictionary: context.dictionary.merging([key : value]) { $1 })
    }
    
}
