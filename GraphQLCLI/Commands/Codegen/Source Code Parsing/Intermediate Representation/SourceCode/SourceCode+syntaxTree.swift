//
//  SyntaxTree.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 12/3/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SwiftSyntax

extension SourceCode {

    func syntaxTree() throws -> SourceFileSyntax {
        return try SyntaxParser.parse(source: content)
    }

}
