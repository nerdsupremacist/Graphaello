//
//  GraphQLValue.swift
//  
//
//  Created by Mathias Quintero on 12/18/19.
//

import Foundation

public indirect enum GraphQLValue: Hashable {
    case dictionary([String : GraphQLValue])
    case array([GraphQLValue])
    case identifier(String)
    case int(Int)
    case double(Double)
    case string(String)
    case bool(Bool)
    case null
}
