//
//  Struct<Stage.Resolved>Resolver.swift
//  Graphaello
//
//  Created by Mathias Quintero on 08.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

struct BasicStructResolver<Resolver: StructResolver>: StructResolver where Resolver.Resolved == [Property<Stage.Resolved>] {
    let resolver: Resolver
    let collector: ResolvedStructCollector
    
    func resolve(validated: Struct<Stage.Validated>,
                 using context: StructResolution.Context) throws -> StructResolution.Result<Struct<Stage.Resolved>> {
        
        return try resolver
            .resolve(validated: validated, using: context)
            .flatMap { properties in
                try collector.collect(from: properties, for: validated)
            }
    }
}

extension BasicStructResolver {
    
    init(resolver: () -> Resolver, collector: () -> ResolvedStructCollector) {
        self.resolver = resolver()
        self.collector = collector()
    }
    
}
