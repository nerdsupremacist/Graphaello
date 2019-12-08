//
//  PathFromMemberAccessParser.swift
//  Graphaello
//
//  Created by Mathias Quintero on 12/8/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SwiftSyntax

struct PathFromMemberAccessParser: SubParser {
    let parent: AnyParser<ExprSyntax, Stage.Parsed.Path>
    let baseMemberAccessParser: PathFromBaseMemberAccessParser

    func parse(from expression: MemberAccessExprSyntax) throws -> Stage.Parsed.Path {
        switch expression.base {
        case .some(let base as IdentifierExprSyntax):
            let access = BaseMemberAccess(base: base.identifier.text, accessedField: expression.name.text)
            return try baseMemberAccessParser.parse(from: access)
        case .some(let base):
            return try parent.parse(from: base).appending(name: expression.name.text)
        default:
            throw ParseError.expectedBaseForCalls(expression: expression)
        }
    }
}

extension Stage.Parsed.Path {

    fileprivate func appending(name: String) -> Self {
        return .init(apiName: apiName,
                     target: target,
                     components: components + [name == "fragment" ? .fragment : .property(name)])
    }

}
