//
//  QueryArgumentFromMemberAccessParser.swift
//  Graphaello
//
//  Created by Mathias Quintero on 12/8/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SwiftSyntax

struct QueryArgumentFromMemberAccessParser: SubParser {
    func parse(from expression: MemberAccessExprSyntax) throws -> Argument.QueryArgument {
        if expression.name.text == "forced" {
            return .forced
        } else {
            return .withDefault(expression)
        }
    }
}
