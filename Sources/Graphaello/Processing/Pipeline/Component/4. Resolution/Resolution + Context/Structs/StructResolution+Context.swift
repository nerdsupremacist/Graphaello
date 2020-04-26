//
//  StructResolution+Context.swift
//  Graphaello
//
//  Created by Mathias Quintero on 08.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

extension StructResolution {
    
    struct Context {
        private struct FastStruct {
            let fragments: [String : GraphQLFragment]
            
            init(resolved: Struct<Stage.Resolved>) {
                self.fragments = Dictionary(uniqueKeysWithValues: resolved.fragments.map { ($0.target.name.lowercased(), $0) })
            }
        }

        let resolved: [Struct<Stage.Resolved>]
        private let fragmentDictionary: [String : GraphQLFragment]
        private let structsDictionary: [String : FastStruct]
        public let failedDueToMissingFragment: [Struct<Stage.Validated>]
        
        private init(resolved: [Struct<Stage.Resolved>],
                     fragmentDictionary: [String : GraphQLFragment],
                     structsDictionary: [String : FastStruct],
                     failedDueToMissingFragment: [Struct<Stage.Validated>]) {
            
            self.resolved = resolved
            self.fragmentDictionary = fragmentDictionary
            self.structsDictionary = structsDictionary
            self.failedDueToMissingFragment = failedDueToMissingFragment
        }
    }
    
}

extension StructResolution.Context {
    
    var isEmpty: Bool {
        return fragmentDictionary.isEmpty && structsDictionary.isEmpty
    }
    
}

extension StructResolution.Context {
    
    subscript(name: StructResolution.FragmentName) -> GraphQLFragment? {
        switch name {
        case .fullName(let name):
            return fragmentDictionary[name]
        case .typealiasOnStruct(let structName, let typeName):
            return structsDictionary[structName]?.fragments[typeName.lowercased()]
        }
    }
    
}

extension StructResolution.Context {
    
    static let empty = StructResolution.Context(resolved: [],
                                                fragmentDictionary: [:],
                                                structsDictionary: [:],
                                                failedDueToMissingFragment: [])
    
    static func + (lhs: StructResolution.Context,
                   rhs: @autoclosure () throws -> StructResolution.StructResult<Struct<Stage.Resolved>>) rethrows -> StructResolution.Context {
        
        switch try rhs() {
        case .resolved(let resolved):
            return lhs + resolved
        case .missingFragment(let missing):
            return lhs + missing
        }
    }
    
    static func + (lhs: StructResolution.Context, rhs: Struct<Stage.Resolved>) -> StructResolution.Context {
        let fragmentDictionary = Dictionary(uniqueKeysWithValues: rhs.fragments.map { ($0.name, $0) }).merging(lhs.fragmentDictionary) { $1 }
        let structsDictionary = [rhs.name : FastStruct(resolved: rhs)].merging(lhs.structsDictionary) { $1 }
        
        return StructResolution.Context(resolved: lhs.resolved + [rhs],
                                        fragmentDictionary: fragmentDictionary,
                                        structsDictionary: structsDictionary,
                                        failedDueToMissingFragment: lhs.failedDueToMissingFragment)
    }
    
    static func + (lhs: StructResolution.Context, rhs: Struct<Stage.Validated>) -> StructResolution.Context {
        return StructResolution.Context(resolved: lhs.resolved,
                                        fragmentDictionary: lhs.fragmentDictionary,
                                        structsDictionary: lhs.structsDictionary,
                                        failedDueToMissingFragment: lhs.failedDueToMissingFragment + [rhs])
    }


}

extension StructResolution.Context {
    
    func cleared() -> StructResolution.Context {
        return StructResolution.Context(resolved: resolved,
                                        fragmentDictionary: fragmentDictionary,
                                        structsDictionary: structsDictionary,
                                        failedDueToMissingFragment: [])
    }
    
}
