//
//  SourceCode+singleExpression.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 12/4/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

extension SourceCode {

    static func singleExpression(content: String) throws -> SourceCode {
        let code = try SourceCode(content: content)
        let substructure = try code.substructure()
        return try substructure.single() ?! ParseError.expectedSingleSubtructure(in: substructure)
    }

}
