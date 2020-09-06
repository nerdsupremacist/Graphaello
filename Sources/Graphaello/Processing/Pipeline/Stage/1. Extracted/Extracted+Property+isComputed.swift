import Foundation
import SwiftSyntax

extension Property where CurrentStage == Stage.Extracted {
    
    func isComputed() throws -> Bool {
        if case .concrete(let type) = type, type.hasPrefix("some ") {
            return true
        }
        
        guard let expression = try code.syntaxTree().singleItem()?.as(VariableDeclSyntax.self) else { return false }
        return expression.bindings.contains { $0.accessor != nil }
    }
    
}
