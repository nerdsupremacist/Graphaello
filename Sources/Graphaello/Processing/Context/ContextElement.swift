//
//  ContextElement.swift
//  
//
//  Created by Mathias Quintero on 31.12.19.
//

import Foundation

protocol ContextElement: ContextProtocol {
    var key: Context.Key<Self> { get }
}

extension ContextElement {
    
    func merge(with context: Context) -> Context {
        return context + (key ~> self)
    }
    
}
