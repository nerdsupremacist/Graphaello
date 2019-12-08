//
//  StructResolution.swift
//  Graphaello
//
//  Created by Mathias Quintero on 08.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

enum StructResolution {
    enum Result<Value> {
        case resolved(Value)
        case missingFragment
    }
    
    enum StructResult<Value> {
        case resolved(Value)
        case missingFragment(Struct<Stage.Validated>)
    }
    
    enum FragmentName {
        case fullName(String)
        case typealiasOnStruct(String, String)
    }
    
    struct Context {
        private struct FastStruct {
            let resolved: GraphQLStruct
            let fragments: [String : GraphQLFragment]
            
            init(resolved: GraphQLStruct) {
                self.resolved = resolved
                self.fragments = Dictionary(uniqueKeysWithValues: resolved.fragments.map { ($0.target.name, $0) })
            }
        }
        
        private let fragmentDictionary: [String : GraphQLFragment]
        private let structsDictionary: [String : FastStruct]
        public let failedDueToMissingFragment: [Struct<Stage.Validated>]
        
        private init(fragmentDictionary: [String : GraphQLFragment],
                     structsDictionary: [String : FastStruct],
                     failedDueToMissingFragment: [Struct<Stage.Validated>]) {
            
            self.fragmentDictionary = fragmentDictionary
            self.structsDictionary = structsDictionary
            self.failedDueToMissingFragment = failedDueToMissingFragment
        }
    }
}

extension StructResolution.Context {
    
    subscript(name: StructResolution.FragmentName) -> GraphQLFragment? {
        switch name {
        case .fullName(let name):
            return fragmentDictionary[name]
        case .typealiasOnStruct(let structName, let typeName):
            return structsDictionary[structName]?.fragments[typeName]
        }
    }
    
}

extension StructResolution.Context {
    
    static let empty = StructResolution.Context(fragmentDictionary: [:],
                                                structsDictionary: [:],
                                                failedDueToMissingFragment: [])
    
    static func + (lhs: StructResolution.Context,
                   rhs: @autoclosure () throws -> StructResolution.StructResult<GraphQLStruct>) rethrows -> StructResolution.Context {
        
        switch try rhs() {
        case .resolved(let resolved):
            return lhs + resolved
        case .missingFragment(let missing):
            return lhs + missing
        }
    }
    
    static func + (lhs: StructResolution.Context, rhs: GraphQLStruct) -> StructResolution.Context {
        let fragmentDictionary = Dictionary(uniqueKeysWithValues: rhs.fragments.map { ($0.name, $0) }).merging(lhs.fragmentDictionary) { $1 }
        let structsDictionary = [rhs.definition.name : FastStruct(resolved: rhs)].merging(lhs.structsDictionary) { $1 }
        
        return StructResolution.Context(fragmentDictionary: fragmentDictionary,
                                        structsDictionary: structsDictionary,
                                        failedDueToMissingFragment: lhs.failedDueToMissingFragment)
    }
    
    static func + (lhs: StructResolution.Context, rhs: Struct<Stage.Validated>) -> StructResolution.Context {
        return StructResolution.Context(fragmentDictionary: lhs.fragmentDictionary,
                                        structsDictionary: lhs.structsDictionary,
                                        failedDueToMissingFragment: lhs.failedDueToMissingFragment + [rhs])
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

extension StructResolution.Context {
    
    func cleared() -> StructResolution.Context {
        return StructResolution.Context(fragmentDictionary: fragmentDictionary,
                                        structsDictionary: structsDictionary,
                                        failedDueToMissingFragment: [])
    }
    
}

extension Sequence {
    
    func collect<Value>(transform: (Element) throws -> StructResolution.Result<Value>) rethrows -> StructResolution.Result<[Value]> {
        var collected = [Value]()
        for element in self {
            switch try transform(element) {
            case .resolved(let value):
                collected.append(value)
            case .missingFragment:
                return .missingFragment
            }
        }
        return .resolved(collected)
    }
    
}

extension StructResolution.Context {
    
    var resolved: [GraphQLStruct] {
        return structsDictionary.values.map { $0.resolved }
    }
    
}
