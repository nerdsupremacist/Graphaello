//
//  File.swift
//  
//
//  Created by Mathias Quintero on 12/18/19.
//

import Foundation
import Ogma

extension Dictionary: Parsable where Key == String, Value == GraphQLValue {
    public typealias Token = GraphQLValue.Token

    public static let parser: AnyParser<Token, [String : GraphQLValue]> = {
        let key: AnyParser<Token, String> = .consuming { token in
            switch token {
            case .string(let string):
                return string
            case .identifier(let identifier):
                return identifier
            default:
                return nil
            }
        }

        let element = key && .colon && Value.self
        return element
            .separated(by: .comma, allowsTrailingSeparator: true, allowsEmpty: true)
            .map { Dictionary($0, uniquingKeysWith: { $1 }) }
            .wrapped(by: .openCurlyBracket, and: .closeCurlyBracket)
    }()
}
