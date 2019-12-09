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
        
        switch value.parsed {
        case .property(let name):
            return .resolved(.scalar(.direct(name)))
        
        case .fragment:
            guard let fragment = parent.referencedFragment else { return .missingFragment }
            return .resolved(.fragment(fragment))
            
        case .call(let name, let arguments):
            return .resolved(.scalar(.call(name, arguments)))
        
        }
    }
}
