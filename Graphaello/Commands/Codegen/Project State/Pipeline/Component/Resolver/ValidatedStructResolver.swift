//
//  ValidatedStructResolver.swift
//  Graphaello
//
//  Created by Mathias Quintero on 08.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

struct ValidatedStructResolver<Resolver: ValueResolver>: StructResolver where Resolver.Value == Property<Stage.Validated>, Resolver.Resolved == Property<Stage.Resolved>, Resolver.Parent == Struct<Stage.Validated> {
    let resolver: Resolver
    
    func resolve(validated: Struct<Stage.Validated>,
                 using context: StructResolution.Context) throws -> StructResolution.Result<Struct<Stage.Resolved>> {
        
        return try validated
            .properties
            .collect { property in
                try resolver.resolve(value: property, in: validated, using: context)
            }
            .map { properties in
                Struct(code: validated.code, name: validated.name, properties: properties)
            }
    }
    
}

extension ValidatedStructResolver {
    
    init(resolver: () -> Resolver) {
        self.resolver = resolver()
    }
    
}
