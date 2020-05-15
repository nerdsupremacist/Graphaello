import Foundation

struct ResolvedComponentCollector: ResolvedValueCollector {
    func collect(from value: Stage.Validated.Component,
                 in parent: Stage.Resolved.Path) -> StructResolution.Result<CollectedPath.Valid?> {
        
        switch (value.reference, value.parsed) {
        case (_, .operation), (.type, _):
            return .resolved(nil)
        case (.casting(.up), _):
            return .resolved(nil)
        case (.casting(.down), _):
            return .resolved(.typeConditional(value.underlyingType, .empty))
            
        case (.field(let field), .property):
            return .resolved(.scalar(.direct(field)))
        
        case (_, .fragment), (.fragment, _):
            switch parent.referencedFragment {
            case .some(.fragment(let fragment)):
                return .resolved(.fragment(fragment))
            case .some(.connection(let connection)):
                return .resolved(.connection(connection))
            case .some(.mutationResult(let fragment)):
                return .resolved(.fragment(fragment))
            case .none:
                return .missingFragment
            }
            
        case (.field(let field), .call(_, let arguments)):
            return .resolved(.scalar(.call(field, arguments)))
        
        }
    }
}
