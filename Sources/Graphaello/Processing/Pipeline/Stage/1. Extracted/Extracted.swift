import Foundation
import SourceKittenFramework

extension Stage {

    // All structs and their properties were extracted from the project
    enum Extracted: StageProtocol {
        struct Attribute {
            let code: SourceCode
            let kind: SwiftDeclarationAttributeKind
        }
    }

}

extension Property where CurrentStage == Stage.Extracted {
    
    var attributes: [Stage.Extracted.Attribute] {
        return context[.attributes]
    }
    
}

extension Context.Key where T == [Stage.Extracted.Attribute] {
    
    static let attributes = Context.Key<[Stage.Extracted.Attribute]>()
    
}
