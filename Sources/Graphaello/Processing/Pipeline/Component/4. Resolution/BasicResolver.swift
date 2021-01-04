import Foundation

struct BasicResolver<SubResolver: StructResolver>: Resolver where SubResolver.Resolved == Struct<Stage.Resolved> {
    let resolver: SubResolver
    
    func resolve(validated: [Struct<Stage.Validated>]) throws -> [Struct<Stage.Resolved>] {
        return try resolve(validated: validated, using: .empty)
    }
    
    private func resolve(validated: [Struct<Stage.Validated>], using context: StructResolution.Context) throws -> [Struct<Stage.Resolved>] {
        guard !validated.isEmpty else { return context.resolved }
        
        let finalContext = try validated.reduce(context) { context, validated in
            return try context + resolver.resolve(validated: validated, using: context).map(to: validated)
        }
        
        let missing = finalContext.failedDueToMissingFragment
        
        guard missing.count < validated.count else {
            throw GraphQLFragmentResolverError.failedToDecodeImportedFragments(missing, resolved: finalContext.resolved)
        }
        
        return try resolve(validated: missing, using: finalContext.cleared())
    }
}

extension BasicResolver {
    
    init(resolver: () -> SubResolver) {
        self.resolver = resolver()
    }
    
}
