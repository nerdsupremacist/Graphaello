//
//  ArgumentFromMemberAccessParser.swift
//  Graphaello
//
//  Created by Mathias Quintero on 12/8/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SwiftSyntax

extension SubParser {
    
    static func memberAccess() -> SubParser<MemberAccessExprSyntax, Argument> {
        return .init { member in
            guard member.name.text == "argument" else {
                throw ParseError.cannotInstantiateObjectFromExpression(member, type: Argument.self)
            }
            return .argument(.forced)
        }
    }
    
}
