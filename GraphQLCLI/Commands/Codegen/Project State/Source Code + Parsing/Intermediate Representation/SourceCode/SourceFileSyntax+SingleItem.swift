//
//  SourceFileSyntax+SingleItem.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 06.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SwiftSyntax

extension SourceFileSyntax {
    
    func singleItem() -> Syntax? {
        return Array(statements).single()?.item
    }
    
}
