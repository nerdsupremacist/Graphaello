//
//  PathFromMemberAccessParser.swift
//  Graphaello
//
//  Created by Mathias Quintero on 12/8/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SwiftSyntax

extension SubParser {
    
    static func memberAccess(extracted: Stage.Extracted.Attribute,
                             parent: SubParser<ExprSyntax, Stage.Parsed.Path>,
                             parser: @escaping () -> SubParser<BaseMemberAccess, Stage.Parsed.Path>) -> SubParser<MemberAccessExprSyntax, Stage.Parsed.Path> {
        
        return .init { expression in
            guard let base = expression.base else { throw ParseError.expectedBaseForCalls(expression: expression.erased()) }

            if let base = base.as(IdentifierExprSyntax.self) {
                let access = BaseMemberAccess(extracted: extracted, base: base.identifier.text, accessedField: expression.name.text)
                return try parser().parse(from: access)
            }

            return try parent.parse(from: base).appending(name: expression.name.text)
        }
    }
    
}

extension Stage.Parsed.Path {

    fileprivate func appending(name: String) -> Self {
        return .init(extracted: extracted,
                     apiName: apiName,
                     target: target,
                     components: components + [name == "_fragment" ? .fragment : .property(name)])
    }

}
