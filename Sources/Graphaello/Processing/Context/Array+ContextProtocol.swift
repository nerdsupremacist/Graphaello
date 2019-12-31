//
//  File.swift
//  
//
//  Created by Mathias Quintero on 31.12.19.
//

import Foundation

extension Array: ContextProtocol where Element: ContextProtocol {
    
    func merge(with context: Context) -> Context {
        return reduce(context) { $1.merge(with: $0) }
    }
    
}
