//
//  String+lowerCasingFirst.swift
//  Graphaello
//
//  Created by Mathias Quintero on 06.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

// Copied from https://gist.github.com/reitzig/67b41e75176ddfd432cb09392a270218
fileprivate let badChars = CharacterSet.alphanumerics.inverted

extension String {
    var uppercasingFirst: String {
        return prefix(1).uppercased() + dropFirst().lowercased()
    }

    var lowercasingFirst: String {
        return prefix(1).lowercased() + dropFirst().lowercased()
    }

    var camelized: String {
        guard !isEmpty else {
            return ""
        }
        
        guard uppercased() != self else { return lowercased() }

        let parts = self.parts
        let first = String(describing: parts.first!).lowercasingFirst
        let rest = parts.dropFirst().map({String($0).uppercasingFirst})

        return ([first] + rest).joined(separator: "")
    }

    var upperCamelized: String {
        guard !isEmpty else {
            return ""
        }

        return parts.map { String($0).uppercasingFirst }.joined(separator: "")
    }

    private var parts: [String] {
        return replacingOccurrences(of: "([a-z])([A-Z]*)([A-Z][a-z]|$)",
                                    with: "$1 $2 $3",
                                    options: .regularExpression).components(separatedBy: badChars)
    }
}
