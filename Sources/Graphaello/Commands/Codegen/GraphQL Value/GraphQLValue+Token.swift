//
//  File.swift
//  
//
//  Created by Mathias Quintero on 12/18/19.
//

import Foundation
import Ogma

extension GraphQLValue {

    public enum Token: TokenProtocol {
        case openCurlyBracket
        case closeCurlyBracket

        case openSquareBracket
        case closeSquareBracket

        case comma
        case colon

        case `true`
        case `false`

        case identifier(String)
        case string(String)

        case double(Double)
        case int(Int)

        case null
    }

}
