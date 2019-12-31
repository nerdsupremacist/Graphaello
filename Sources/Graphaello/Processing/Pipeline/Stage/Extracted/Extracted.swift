//
//  Extracted.swift
//  Graphaello
//
//  Created by Mathias Quintero on 12/8/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SourceKittenFramework

extension Stage {

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
