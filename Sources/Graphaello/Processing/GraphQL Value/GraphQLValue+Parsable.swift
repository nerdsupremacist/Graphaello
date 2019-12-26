//
//  File.swift
//  
//
//  Created by Mathias Quintero on 12/18/19.
//

import Foundation
import Ogma

extension GraphQLValue: Parsable {

    public static let parser: AnyParser<Token, GraphQLValue> = Array<GraphQLValue>.map(GraphQLValue.array) ||
        Dictionary<String, GraphQLValue>.map(GraphQLValue.dictionary) ||
        AnyParser.consuming { token in
            switch token {
            case .identifier(let identifier):
                return .identifier(identifier)
            case .int(let int):
                return .int(int)
            case .double(let double):
                return .double(double)
            case .string(let string):
                return .string(string)
            case .true:
                return .bool(true)
            case .false:
                return .bool(false)
            case .null:
                return .null
            case .openCurlyBracket, .closeCurlyBracket, .openSquareBracket, .closeSquareBracket, .comma, .colon:
                return nil
            }
        }

}
