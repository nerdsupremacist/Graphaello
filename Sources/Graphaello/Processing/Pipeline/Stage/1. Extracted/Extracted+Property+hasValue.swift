//
//  File.swift
//  
//
//  Created by Mathias Quintero on 12.01.20.
//

import Foundation
import SwiftSyntax

extension Property where CurrentStage == Stage.Extracted {
    
    func hasValue() throws -> Bool {
        guard let expression = try code.syntaxTree().singleItem()?.as(VariableDeclSyntax.self) else { return false }
        return expression.bindings.contains { $0.initializer != nil }
    }
    
}
