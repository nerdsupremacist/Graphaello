//
//  CollectedValue.swift
//  Graphaello
//
//  Created by Mathias Quintero on 09.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

extension StructResolution {

    enum CollectedValue {
        case query(GraphQLQuery)
        case fragment(GraphQLFragment)
        case connectionQuery(GraphQLConnectionQuery)
    }
    
}

extension Struct where CurrentStage == Stage.Resolved {
    
    static func + (lhs: Struct<Stage.Resolved>, rhs: StructResolution.CollectedValue) throws -> Struct<Stage.Resolved> {
        switch rhs {
        case .query(let query):
            return try lhs + query
        case .fragment(let fragment):
            return lhs + fragment
        case .connectionQuery(let connectionQuery):
            return lhs + connectionQuery
        }
    }
    
}
