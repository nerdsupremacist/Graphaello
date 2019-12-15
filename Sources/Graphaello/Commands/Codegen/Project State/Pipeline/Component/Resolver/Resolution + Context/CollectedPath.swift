//
//  ResolvedPath.swift
//  Graphaello
//
//  Created by Mathias Quintero on 09.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

enum CollectedPath {
    indirect enum Valid {
        case scalar(Field)
        case object(Field, Valid)
        case fragment(GraphQLFragment)
    }
    
    case valid(Valid)
    case empty
}

extension CollectedPath {
    
    
    static func + (lhs: CollectedPath, rhs: CollectedPath.Valid) -> CollectedPath {
        switch lhs {
        case .valid(let valid):
            return .valid(valid + rhs)
        case .empty:
            return .valid(rhs)
        }
    }
    
}

extension CollectedPath.Valid {
    

    static func + (lhs: CollectedPath.Valid, rhs: CollectedPath.Valid) -> CollectedPath.Valid {
        switch lhs {
        case .scalar(let field):
            return .object(field, rhs)
        case .object(let field, let valid):
            return .object(field, valid + rhs)
        case fragment:
            fatalError("Unexpected extra value appended to fragment")
        }
        
    }
    
}
