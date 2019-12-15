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
    }
    
}

extension GraphQLStruct {
    
    static func + (lhs: GraphQLStruct, rhs: StructResolution.CollectedValue) throws -> GraphQLStruct {
        switch rhs {
        case .query(let query):
            return try lhs + query
        case .fragment(let fragment):
            return lhs + fragment
        }
    }
    
}
