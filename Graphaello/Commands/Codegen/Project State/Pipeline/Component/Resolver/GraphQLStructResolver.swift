//
//  GraphQLStructResolver.swift
//  Graphaello
//
//  Created by Mathias Quintero on 08.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

struct GraphQLStructResolver<Resolver: StructResolver>: StructResolver where Resolver.Resolved == Struct<Stage.Resolved> {
    let resolver: Resolver
    
    func resolve(validated: Struct<Stage.Validated>,
                 using context: StructResolution.Context) throws -> StructResolution.Result<GraphQLStruct> {
        
        return try resolver
            .resolve(validated: validated, using: context)
            .map { definition in
                GraphQLStruct(definition: definition, fragments: [], query: nil)
            }
    }
}

extension GraphQLStructResolver {
    
    init(resolver: () -> Resolver) {
        self.resolver = resolver()
    }
    
}
