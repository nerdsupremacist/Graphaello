//
//  ParsedProperty+isComputed.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 06.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SwiftSyntax

extension Property where CurrentStage == Stage.Extracted {
    
    func isComputed() throws -> Bool {
        guard !attributes.contains(where: { $0.kind == ._custom }) else { return false }
        guard let expression = try code.syntaxTree().singleItem() as? VariableDeclSyntax else { return false }
        return expression.bindings.contains { $0.accessor != nil }
    }
    
}
