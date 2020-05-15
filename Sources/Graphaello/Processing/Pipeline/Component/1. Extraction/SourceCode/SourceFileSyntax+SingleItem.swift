import Foundation
import SwiftSyntax

extension SourceFileSyntax {
    
    func singleItem() -> Syntax? {
        return Array(statements).single()?.item
    }
    
}
