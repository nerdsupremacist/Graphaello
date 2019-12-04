//
//  GraphQLPath+Component+Argument.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 12/4/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SwiftSyntax

extension GraphQLPath.Component {

    enum Argument {
        enum QueryArgument {
            case withDefault(ExprSyntax)
            case forced
        }

        case value(ExprSyntax)
        case argument(QueryArgument)
    }

}
