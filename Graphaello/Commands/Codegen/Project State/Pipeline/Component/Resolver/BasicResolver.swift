//
//  BasicResolver.swift
//  Graphaello
//
//  Created by Mathias Quintero on 08.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

struct BasicResolver<SubResolver: StructResolver>: Resolver where SubResolver.Resolved == GraphQLStruct {
    let resolver: SubResolver
    
    func resolve(validated: [Struct<Stage.Validated>]) throws -> [GraphQLStruct] {
        return try resolve(validated: validated, using: .empty)
    }
    
    private func resolve(validated: [Struct<Stage.Validated>], using context: StructResolution.Context) throws -> [GraphQLStruct] {
        guard !validated.isEmpty else { return context.resolved }
        
        let finalContext = try validated.reduce(context) { context, validated in
            return try context + resolver.resolve(validated: validated, using: context).map(to: validated)
        }
        
        let missing = finalContext.failedDueToMissingFragment
        
        guard missing.count != validated.count else { throw GraphQLFragmentResolverError.failedToDecodeAnyOfTheStructsDueToPossibleRecursion(missing) }
        
        return try resolve(validated: missing, using: context)
    }
}

extension BasicResolver {
    
    init(resolver: () -> SubResolver) {
        self.resolver = resolver()
    }
    
}
