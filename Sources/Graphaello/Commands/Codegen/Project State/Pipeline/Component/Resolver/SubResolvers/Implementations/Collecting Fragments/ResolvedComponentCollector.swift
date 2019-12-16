//
//  ResolvedComponentCollector.swift
//  Graphaello
//
//  Created by Mathias Quintero on 09.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

struct ResolvedComponentCollector: ResolvedValueCollector {
    func collect(from value: Stage.Validated.Component,
                 in parent: Stage.Resolved.Path) -> StructResolution.Result<CollectedPath.Valid> {
        
        switch (value.reference, value.parsed) {
        case (.casting(.up), _), (.casting(.down), _):
            // TODO: Figure out what should be resolved here
            fatalError()
            
        case (.field(let field), .property):
            return .resolved(.scalar(.direct(field)))
        
        case (_, .fragment), (.fragment, _):
            guard let fragment = parent.referencedFragment else { return .missingFragment }
            return .resolved(.fragment(fragment))
            
        case (.field(let field), .call(_, let arguments)):
            return .resolved(.scalar(.call(field, arguments)))
        
        }
    }
}
