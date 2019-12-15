//
//  QueryArgumentFromMemberAccessParser.swift
//  Graphaello
//
//  Created by Mathias Quintero on 12/8/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SwiftSyntax

extension SubParser {
    
    static func memberAccess() -> SubParser<MemberAccessExprSyntax, Argument.QueryArgument> {
        return .init { expression in
            if expression.name.text == "forced" {
                return .forced
            } else {
                return .withDefault(expression)
            }
        }
    }
    
}
