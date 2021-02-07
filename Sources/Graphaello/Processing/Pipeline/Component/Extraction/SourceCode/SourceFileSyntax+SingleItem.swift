import Foundation
import SwiftSyntax

extension SourceFileSyntax {
    
    func singleItem() -> Syntax? {
        return statements.filter { !$0.item.isUnknown }.single()?.item
    }
    
}
