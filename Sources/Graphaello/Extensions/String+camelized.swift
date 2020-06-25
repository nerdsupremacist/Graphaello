import Foundation

// Copied and adapted from https://gist.github.com/reitzig/67b41e75176ddfd432cb09392a270218
// Modifications made public at: https://gist.github.com/nerdsupremacist/8e620beb2dcf6404f9edcac756ed28dc
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

    var snakeCased: String {
        guard !isEmpty else {
            return ""
        }

        return parts.map { String($0).lowercased() }.joined(separator: "_")
    }
    

    var snakeUpperCased: String {
        return snakeCased.uppercased()
    }
    
    private var parts: [String] {
        let basics = replacingOccurrences(of: "([a-z])([A-Z])",
                                          with: "$1 $2",
                                          options: .regularExpression)

        let complete = basics.replacingOccurrences(of: "([A-Z]+)([A-Z][a-z]|$)",
                                                   with: "$1 $2",
                                                   options: .regularExpression)

        return complete.components(separatedBy: badChars)
    }
}
