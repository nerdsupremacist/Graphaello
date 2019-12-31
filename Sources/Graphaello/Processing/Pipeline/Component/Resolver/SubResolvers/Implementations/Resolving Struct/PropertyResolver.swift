//
//  PropertyResolver.swift
//  Graphaello
//
//  Created by Mathias Quintero on 08.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

struct PropertyResolver<Resolver: ValueResolver>: ValueResolver where Resolver.Parent == Property<Stage.Validated>, Resolver.Value == Stage.Validated.Path, Resolver.Resolved == Stage.Resolved.Path {
    let resolver: Resolver
    
    func resolve(value: Property<Stage.Validated>,
                 in parent: Struct<Stage.Validated>,
                 using context: StructResolution.Context) throws -> StructResolution.Result<Property<Stage.Resolved>> {
        
        guard let path = value.graphqlPath else {
            return .resolved(Property(code: value.code, name: value.name, type: value.type, graphqlPath: nil))
        }
        
        return try resolver
            .resolve(value: path, in: value, using: context)
            .map { path in
                Property(code: value.code, name: value.name, type: value.type, graphqlPath: path)
            }
    }
    
}

extension PropertyResolver {
    
    init(resolver: () -> Resolver) {
        self.resolver = resolver()
    }
    
}
