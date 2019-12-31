//
//  ValidatedStructResolver.swift
//  Graphaello
//
//  Created by Mathias Quintero on 08.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

struct StructPropertiesResolver<Resolver: ValueResolver>: StructResolver where Resolver.Value == Property<Stage.Validated>, Resolver.Resolved == Property<Stage.Resolved>, Resolver.Parent == Struct<Stage.Validated> {
    let resolver: Resolver
    
    func resolve(validated: Struct<Stage.Validated>,
                 using context: StructResolution.Context) throws -> StructResolution.Result<[Property<Stage.Resolved>]> {
        
        return try validated
            .properties
            .collect { property in
                try resolver.resolve(value: property, in: validated, using: context)
            }
    }
    
}

extension StructPropertiesResolver {
    
    init(resolver: () -> Resolver) {
        self.resolver = resolver()
    }
    
}
