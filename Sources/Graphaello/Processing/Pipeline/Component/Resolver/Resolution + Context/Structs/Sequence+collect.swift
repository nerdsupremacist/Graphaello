//
//  Sequence+collect.swift
//  Graphaello
//
//  Created by Mathias Quintero on 08.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

extension Sequence {
    
    func collect<Value>(transform: (Element) throws -> StructResolution.Result<Value>) rethrows -> StructResolution.Result<[Value]> {
        var collected = [Value]()
        for element in self {
            switch try transform(element) {
            case .resolved(let value):
                collected.append(value)
            case .missingFragment:
                return .missingFragment
            }
        }
        return .resolved(collected)
    }
    
}
