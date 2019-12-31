//
//  Assembled.swift
//  
//
//  Created by Mathias Quintero on 31.12.19.
//

import Foundation

extension Stage {
    
    enum Assembled: GraphQLStage, AssembledStage {
        static var pathKey = Context.Key.cleaned
    }
    
}
