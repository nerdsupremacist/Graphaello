//
//  BasicResolvedStructCollector.swift
//  Graphaello
//
//  Created by Mathias Quintero on 09.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

struct BasicResolvedStructCollector<Collector: ResolvedValueCollector>: ResolvedStructCollector where Collector.Resolved == Property<Stage.Resolved>, Collector.Parent == Struct<Stage.Validated>, Collector.Collected == [StructResolution.CollectedValue] {
    let collector: Collector
    
    func collect(from properties: [Property<Stage.Resolved>], for validated: Struct<Stage.Validated>) throws -> StructResolution.Result<Struct<Stage.Resolved>> {
        return try properties
            .collect { property in
                return try collector.collect(from: property, in: validated)
            }
            .map { values in
                return values.flatMap {  $0 }
            }
            .map { values in
                let initialResult = validated.with(properties: properties) {
                    (.fragments ~> [])
                    (.query ~> nil)
                    (.connectionQueries ~> [])
                }
                
                return try values.reduce(initialResult) { try $0 + $1 }
            }
    }
}

extension BasicResolvedStructCollector {
    
    init(collector: () -> Collector) {
        self.collector = collector()
    }
    
}
