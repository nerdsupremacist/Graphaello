//
//  ValueExtractor.swift
//  Graphaello
//
//  Created by Mathias Quintero on 09.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

protocol ResolvedValueCollector {
    associatedtype Resolved
    associatedtype Parent
    associatedtype Collected
    
    func collect(from value: Resolved, in parent: Parent) throws -> StructResolution.Result<Collected>
}
