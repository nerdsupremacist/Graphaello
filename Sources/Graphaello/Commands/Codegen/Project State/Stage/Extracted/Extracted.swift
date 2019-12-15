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
        typealias Information = [Attribute]

        struct Attribute {
            let code: SourceCode
            let kind: SwiftDeclarationAttributeKind
        }
    }

}
