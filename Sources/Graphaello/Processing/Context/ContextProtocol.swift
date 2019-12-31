//
//  ContextProtocol.swift
//  
//
//  Created by Mathias Quintero on 31.12.19.
//

import Foundation

protocol ContextProtocol {
    func merge(with context: Context) -> Context
}

func + (lhs: ContextProtocol, rhs: ContextProtocol) -> Context {
    return Context {
        lhs
        rhs
    }
}
