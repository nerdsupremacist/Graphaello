//
//  BasicResolvedStructCollector.swift
//  Graphaello
//
//  Created by Mathias Quintero on 09.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

struct BasicResolvedStructCollector<Collector: ResolvedValueCollector>: ResolvedStructCollector where Collector.Resolved == Property<Stage.Resolved>, Collector.Parent == Struct<Stage.Resolved>, Collector.Collected == [StructResolution.CollectedValue] {
    let collector: Collector
    
    func collect(from value: Struct<Stage.Resolved>) throws -> StructResolution.Result<GraphQLStruct> {
        return try value
            .properties
            .collect { property in
                return try collector.collect(from: property, in: value)
            }
            .map { values in
                return values.flatMap {  $0 }
            }
            .map { values in
                let initialResult = GraphQLStruct(definition: value, fragments: [], query: nil, connectionQueries: [])
                return try values.reduce(initialResult) { try $0 + $1 }
            }
    }
}

extension BasicResolvedStructCollector {
    
    init(collector: () -> Collector) {
        self.collector = collector()
    }
    
}
